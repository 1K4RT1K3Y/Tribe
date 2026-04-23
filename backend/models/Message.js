import mongoose from 'mongoose';

const messageSchema = new mongoose.Schema({
  senderId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  recipientId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  text: {
    type: String,
    required: [true, 'Message text is required'],
    maxlength: 1000,
  },
  image: {
    type: String,
    default: null,
  },
  read: {
    type: Boolean,
    default: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
    index: -1, // For sorting by most recent
  },
});

// Index for efficient queries
messageSchema.index({ senderId: 1, recipientId: 1 });
messageSchema.index({ recipientId: 1, read: 1 });

const Message = mongoose.model('Message', messageSchema);
export default Message;
