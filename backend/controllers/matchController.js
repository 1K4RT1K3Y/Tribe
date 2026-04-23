import Profile from '../models/Profile.js';
import User from '../models/User.js';

// Calculate match score between two profiles
const calculateMatchScore = (userProfile, targetProfile) => {
  let commonInterests = 0;
  let commonHobbies = 0;
  let matchScore = 0;

  // Count common interests
  if (userProfile.interests && targetProfile.interests) {
    commonInterests = userProfile.interests.filter((interest) =>
      targetProfile.interests.includes(interest)
    ).length;
  }

  // Count common hobbies
  if (userProfile.hobbies && targetProfile.hobbies) {
    commonHobbies = userProfile.hobbies.filter((hobby) =>
      targetProfile.hobbies.includes(hobby)
    ).length;
  }

  // Calculate score: 50% interests + 50% hobbies
  const interestScore =
    (commonInterests / (userProfile.interests?.length || 1)) * 50;
  const hobbyScore = (commonHobbies / (userProfile.hobbies?.length || 1)) * 50;

  matchScore = interestScore + hobbyScore;

  return {
    score: Math.round(matchScore),
    commonInterests,
    commonHobbies,
  };
};

// Get suggested users for vibe matching
export const getSuggestedUsers = async (req, res) => {
  try {
    const userId = req.userId;
    const { limit = 10 } = req.query;

    // Get current user's profile
    const userProfile = await Profile.findOne({ userId });

    if (!userProfile) {
      return res.status(404).json({
        success: false,
        message: 'User profile not found. Please complete your profile first.',
      });
    }

    // Get all other user profiles
    const allProfiles = await Profile.find({ userId: { $ne: userId } })
      .populate('userId', 'name email')
      .limit(parseInt(limit) * 3); // Get more to filter and sort

    // Calculate match scores
    const matches = allProfiles
      .map((profile) => {
        const matchData = calculateMatchScore(userProfile, profile);
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
          verified: profile.verified,
          matchScore: matchData.score,
          commonInterests: matchData.commonInterests,
          commonHobbies: matchData.commonHobbies,
        };
      })
      .filter((match) => match.matchScore > 0) // Filter matches with at least 1 common interest/hobby
      .sort((a, b) => b.matchScore - a.matchScore) // Sort by match score descending
      .slice(0, parseInt(limit)); // Get top matches

    res.status(200).json({
      success: true,
      matches,
      totalMatches: matches.length,
      message: `Found ${matches.length} vibe matches for you!`,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to get suggestions',
      error: error.message,
    });
  }
};

// Get matches by specific interest
export const getMatchesByInterest = async (req, res) => {
  try {
    const { interest, limit = 10 } = req.query;
    const userId = req.userId;

    if (!interest) {
      return res.status(400).json({
        success: false,
        message: 'Please specify an interest',
      });
    }

    const profiles = await Profile.find({
      userId: { $ne: userId },
      interests: interest,
    })
      .populate('userId', 'name email')
      .limit(parseInt(limit));

    const matches = profiles.map((profile) => ({
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
      sharedInterest: interest,
    }));

    res.status(200).json({
      success: true,
      matches,
      totalMatches: matches.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to find matches',
      error: error.message,
    });
  }
};

// Get compatibility score between two users
export const getCompatibilityScore = async (req, res) => {
  try {
    const userId = req.userId;
    const { targetUserId } = req.params;

    const userProfile = await Profile.findOne({ userId });
    const targetProfile = await Profile.findOne({ userId: targetUserId });

    if (!userProfile || !targetProfile) {
      return res.status(404).json({
        success: false,
        message: 'One or both profiles not found',
      });
    }

    const matchData = calculateMatchScore(userProfile, targetProfile);

    res.status(200).json({
      success: true,
      userId: targetUserId,
      ...matchData,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to calculate compatibility',
      error: error.message,
    });
  }
};

// Get all available interests (for discovery)
export const getPopularInterests = async (req, res) => {
  try {
    const profiles = await Profile.find({}, { interests: 1 });

    const interestMap = {};
    profiles.forEach((profile) => {
      profile.interests.forEach((interest) => {
        interestMap[interest] = (interestMap[interest] || 0) + 1;
      });
    });

    const popularInterests = Object.entries(interestMap)
      .map(([interest, count]) => ({ interest, userCount: count }))
      .sort((a, b) => b.userCount - a.userCount)
      .slice(0, 20);

    res.status(200).json({
      success: true,
      interests: popularInterests,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch interests',
      error: error.message,
    });
  }
};
