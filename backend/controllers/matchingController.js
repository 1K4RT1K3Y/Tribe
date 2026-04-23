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

// Get Suggested Users (Matching)
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
          profileImage: profile.profileImage,
          matchScore,
          commonInterests: userProfile.interests.filter(interest =>
            profile.interests.includes(interest)
          ),
        };
      })
      .filter(user => user.matchScore > 0) // Only show users with at least 1 common interest
      .sort((a, b) => b.matchScore - a.matchScore) // Sort by match score (highest first)
      .slice(0, 10); // Return top 10 suggestions

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
