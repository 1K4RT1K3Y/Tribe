import Profile from '../models/Profile.js';
import User from '../models/User.js';

// Create Profile (for new user after registration)
export const createProfile = async (req, res) => {
  try {
    const { bio, interests, hobbies, age, location } = req.body;
    const userId = req.userId;

    // Check if profile already exists
    const existingProfile = await Profile.findOne({ userId });
    if (existingProfile) {
      return res.status(400).json({
        success: false,
        message: 'Profile already exists',
      });
    }

    const profile = new Profile({
      userId,
      bio: bio || '',
      interests: interests || [],
      hobbies: hobbies || [],
      age: age || null,
      location: location || '',
    });

    await profile.save();

    // Update user's profileComplete flag
    await User.findByIdAndUpdate(userId, { profileComplete: true });

    res.status(201).json({
      success: true,
      message: 'Profile created successfully',
      profile,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to create profile',
      error: error.message,
    });
  }
};

// Get User Profile
export const getUserProfile = async (req, res) => {
  try {
    const { userId } = req.params;

    const profile = await Profile.findOne({ userId }).populate('userId', 'name email');

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found',
      });
    }

    res.status(200).json({
      success: true,
      profile,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch profile',
      error: error.message,
    });
  }
};

// Get My Profile (authenticated)
export const getMyProfile = async (req, res) => {
  try {
    const profile = await Profile.findOne({ userId: req.userId }).populate(
      'userId',
      'name email'
    );

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found',
      });
    }

    res.status(200).json({
      success: true,
      profile,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch profile',
      error: error.message,
    });
  }
};

// Update Profile
export const updateProfile = async (req, res) => {
  try {
    const { bio, interests, hobbies, age, location, profileImage } = req.body;
    const userId = req.userId;

    // Validation
    if (interests && interests.length > 20) {
      return res.status(400).json({
        success: false,
        message: 'Maximum 20 interests allowed',
      });
    }

    if (hobbies && hobbies.length > 20) {
      return res.status(400).json({
        success: false,
        message: 'Maximum 20 hobbies allowed',
      });
    }

    const updateData = {};
    if (bio !== undefined) updateData.bio = bio;
    if (interests !== undefined) updateData.interests = interests;
    if (hobbies !== undefined) updateData.hobbies = hobbies;
    if (age !== undefined) updateData.age = age;
    if (location !== undefined) updateData.location = location;
    if (profileImage !== undefined) updateData.profileImage = profileImage;
    updateData.updatedAt = new Date();

    const profile = await Profile.findOneAndUpdate({ userId }, updateData, {
      new: true,
      runValidators: true,
    });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      profile,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to update profile',
      error: error.message,
    });
  }
};

// Delete Profile
export const deleteProfile = async (req, res) => {
  try {
    const userId = req.userId;

    const profile = await Profile.findOneAndDelete({ userId });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: 'Profile not found',
      });
    }

    // Update user's profileComplete flag
    await User.findByIdAndUpdate(userId, { profileComplete: false });

    res.status(200).json({
      success: true,
      message: 'Profile deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to delete profile',
      error: error.message,
    });
  }
};
