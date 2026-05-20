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
    let profile = await Profile.findOne({ userId: req.userId }).populate(
      'userId',
      'name email'
    );

    // If profile doesn't exist yet, create a default empty profile
    if (!profile) {
      const newProfile = new Profile({
        userId: req.userId,
        bio: '',
        interests: [],
        hobbies: [],
        age: null,
        location: '',
        profileImage: null,
        verified: false,
      });

      await newProfile.save();

      // Update user's profileComplete flag
      await User.findByIdAndUpdate(req.userId, { profileComplete: true });

      profile = await Profile.findOne({ userId: req.userId }).populate('userId', 'name email');
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
    const { bio, interests, hobbies, age, location, profileImage, occupation, gender, relationshipStatus } = req.body;
    const userId = req.userId;

    // Validation
    if (bio !== undefined && bio.length > 500) {
      return res.status(400).json({
        success: false,
        message: 'Bio cannot exceed 500 characters',
      });
    }

    if (age !== undefined) {
      if (age < 13 || age > 120) {
        return res.status(400).json({
          success: false,
          message: 'Age must be between 13 and 120',
        });
      }
    }

    if (location !== undefined && location.length > 100) {
      return res.status(400).json({
        success: false,
        message: 'Location cannot exceed 100 characters',
      });
    }

    if (occupation !== undefined && occupation.length > 100) {
      return res.status(400).json({
        success: false,
        message: 'Occupation cannot exceed 100 characters',
      });
    }

    if (interests && interests.length > 20) {
      return res.status(400).json({
        success: false,
        message: 'Maximum 20 interests allowed',
      });
    }

    // Validate interests are not empty strings
    if (interests && interests.some(interest => typeof interest !== 'string' || interest.trim().length === 0)) {
      return res.status(400).json({
        success: false,
        message: 'Interests cannot be empty',
      });
    }

    if (hobbies && hobbies.length > 20) {
      return res.status(400).json({
        success: false,
        message: 'Maximum 20 hobbies allowed',
      });
    }

    // Validate hobbies are not empty strings
    if (hobbies && hobbies.some(hobby => typeof hobby !== 'string' || hobby.trim().length === 0)) {
      return res.status(400).json({
        success: false,
        message: 'Hobbies cannot be empty',
      });
    }

    // Validate gender enum
    const validGenders = ['Male', 'Female', 'Non-binary', 'Other', 'Prefer not to say'];
    if (gender !== undefined && !validGenders.includes(gender)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid gender value',
      });
    }

    // Validate relationship status enum
    const validStatuses = ['Single', 'In a relationship', 'Married', 'Prefer not to say'];
    if (relationshipStatus !== undefined && !validStatuses.includes(relationshipStatus)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid relationship status value',
      });
    }

    const updateData = {};
    if (bio !== undefined) updateData.bio = bio.trim();
    if (interests !== undefined) updateData.interests = interests.map(i => i.trim());
    if (hobbies !== undefined) updateData.hobbies = hobbies.map(h => h.trim());
    if (age !== undefined) updateData.age = age;
    if (location !== undefined) updateData.location = location.trim();
    if (profileImage !== undefined) updateData.profileImage = profileImage;
    if (occupation !== undefined) updateData.occupation = occupation.trim();
    if (gender !== undefined) updateData.gender = gender;
    if (relationshipStatus !== undefined) updateData.relationshipStatus = relationshipStatus;
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

    // Mark profile as complete if key fields are filled
    if (interests && interests.length > 0 && occupation && gender && location) {
      await User.findByIdAndUpdate(userId, { profileComplete: true });
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
