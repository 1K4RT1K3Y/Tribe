import Profile from '../models/Profile.js';
import User from '../models/User.js';

// Helper function: Calculate match score based on common interests
const calculateMatchScore = (userInterests, profileInterests) => {
  if (!userInterests || !profileInterests) return 0;
  
  const commonInterests = userInterests.filter(interest =>
    profileInterests.includes(interest)
  );
  
  return commonInterests.length;
};

// Get Suggested Users (Matching - 4+ common interests)
export const getSuggestedUsers = async (req, res) => {
  try {
    const userId = req.userId;

    // Get current user's profile
    const userProfile = await Profile.findOne({ userId }).populate('userId', 'name email');
    
    if (!userProfile) {
      return res.status(404).json({
        success: false,
        message: 'Your profile not found. Please complete your profile first.',
      });
    }

    // Get all other users' profiles
    const allProfiles = await Profile.find({ userId: { $ne: userId } }).populate('userId', 'name email');

    // Calculate match scores and sort
    const suggestedUsers = allProfiles
      .map(profile => {
        const matchScore = calculateMatchScore(
          userProfile.interests,
          profile.interests
        );

        return {
          userId: profile.userId._id,
          userName: profile.userId.name,
          userEmail: profile.userId.email,
          bio: profile.bio,
          interests: profile.interests,
          hobbies: profile.hobbies,
          age: profile.age,
          location: profile.location,
          occupation: profile.occupation,
          gender: profile.gender,
          profileImage: profile.profileImage,
          matchScore,
          commonInterests: userProfile.interests.filter(interest =>
            profile.interests.includes(interest)
          ),
        };
      })
      .filter(user => user.matchScore >= 4) // Only show users with 4+ common interests
      .sort((a, b) => b.matchScore - a.matchScore) // Sort by match score (highest first)
      .slice(0, 20); // Return top 20 suggestions

    res.status(200).json({
      success: true,
      message: 'Suggested users retrieved successfully',
      suggestedUsers,
      totalSuggestions: suggestedUsers.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch suggested users',
      error: error.message,
    });
  }
};

// Get User Profile Details (for viewing suggested user)
export const getUserProfileDetails = async (req, res) => {
  try {
    const { userId } = req.params;

    const profile = await Profile.findOne({ userId }).populate('userId', 'name email');

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'User profile not found',
      });
    }

    res.status(200).json({
      success: true,
      profile: {
        userId: profile.userId._id,
        userName: profile.userId.name,
        userEmail: profile.userId.email,
        bio: profile.bio,
        interests: profile.interests,
        hobbies: profile.hobbies,
        age: profile.age,
        location: profile.location,
        profileImage: profile.profileImage,
        verified: profile.verified,
        createdAt: profile.createdAt,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch user profile',
      error: error.message,
    });
  }
};

// Get All Users with Match Scores (for debugging)
export const getAllUsersWithMatchScores = async (req, res) => {
  try {
    const userId = req.userId;

    const userProfile = await Profile.findOne({ userId }).populate('userId', 'name email');

    if (!userProfile) {
      return res.status(404).json({
        success: false,
        message: 'Your profile not found',
      });
    }

    const allProfiles = await Profile.find({ userId: { $ne: userId } }).populate('userId', 'name email');

    const usersWithScores = allProfiles.map(profile => ({
      userId: profile.userId._id,
      userName: profile.userId.name,
      interests: profile.interests,
      matchScore: calculateMatchScore(userProfile.interests, profile.interests),
    }));

    res.status(200).json({
      success: true,
      yourInterests: userProfile.interests,
      usersWithScores: usersWithScores.sort((a, b) => b.matchScore - a.matchScore),
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to calculate match scores',
      error: error.message,
    });
  }
};

// Search Users by name or interests
export const searchUsers = async (req, res) => {
  try {
    const { query } = req.query;
    const userId = req.userId;

    if (!query || query.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Search query is required',
      });
    }

    // Get current user's profile for match calculation
    const userProfile = await Profile.findOne({ userId }).populate('userId', 'name email');

    // Search users by name
    const users = await User.find({
      _id: { $ne: userId },
      name: { $regex: query, $options: 'i' }, // Case-insensitive search
    });

    // Also search by interests
    const profilesByInterest = await Profile.find({
      userId: { $ne: userId },
      interests: { $regex: query, $options: 'i' },
    }).populate('userId', 'name email');

    const usersByInterest = profilesByInterest.map(p => p.userId);

    // Combine and deduplicate
    const allUserIds = new Set([...users.map(u => u._id), ...usersByInterest.map(u => u._id)]);

    // Get profiles for all found users
    const searchResults = [];
    for (const uid of allUserIds) {
      const profile = await Profile.findOne({ userId: uid }).populate('userId', 'name email');
      const matchScore = userProfile
        ? calculateMatchScore(userProfile.interests, profile.interests)
        : 0;

      searchResults.push({
        userId: profile.userId._id,
        userName: profile.userId.name,
        userEmail: profile.userId.email,
        bio: profile.bio,
        interests: profile.interests,
        hobbies: profile.hobbies,
        age: profile.age,
        location: profile.location,
        occupation: profile.occupation,
        gender: profile.gender,
        profileImage: profile.profileImage,
        matchScore,
        commonInterests: userProfile
          ? userProfile.interests.filter(interest => profile.interests.includes(interest))
          : [],
      });
    }

    // Sort by match score
    searchResults.sort((a, b) => b.matchScore - a.matchScore);

    res.status(200).json({
      success: true,
      message: 'Search results retrieved successfully',
      results: searchResults,
      totalResults: searchResults.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to search users',
      error: error.message,
    });
  }
};

