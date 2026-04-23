import mongoose from 'mongoose';

const profileSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
  },
  bio: {
    type: String,
    maxlength: 500,
    default: '',
  },
  interests: {
    type: [String],
    default: [],
    maxlength: [20, 'Cannot have more than 20 interests'],
  },
  hobbies: {
    type: [String],
    default: [],
    maxlength: [20, 'Cannot have more than 20 hobbies'],
  },
  age: {
    type: Number,
    min: 13,
    max: 120,
  },
  location: {
    type: String,
    default: '',
  },
  profileImage: {
    type: String,
    default: null,
  },
  verified: {
    type: Boolean,
    default: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  updatedAt: {
    type: Date,
    default: Date.now,
  },
});

const Profile = mongoose.model('Profile', profileSchema);
export default Profile;
