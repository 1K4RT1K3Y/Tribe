import Message from '../models/Message.js';
import User from '../models/User.js';

// Send Message
export const sendMessage = async (req, res) => {
  try {
    const { recipientId, text, image } = req.body;
    const senderId = req.userId;

    // Validation
    if (!recipientId || !text) {
      return res.status(400).json({
        success: false,
        message: 'Recipient ID and message text are required',
      });
    }

    // Check if recipient exists
    const recipient = await User.findById(recipientId);
    if (!recipient) {
      return res.status(404).json({
        success: false,
        message: 'Recipient not found',
      });
    }

    // Prevent sending message to self
    if (senderId.toString() === recipientId) {
      return res.status(400).json({
        success: false,
        message: 'Cannot send message to yourself',
      });
    }

    // Create message
    const message = new Message({
      senderId,
      recipientId,
      text,
      image: image || null,
    });

    await message.save();
    await message.populate('senderId', 'name email');
    await message.populate('recipientId', 'name email');

    res.status(201).json({
      success: true,
      message: 'Message sent successfully',
      data: message,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to send message',
      error: error.message,
    });
  }
};

// Get Chat History (between two users)
export const getChatHistory = async (req, res) => {
  try {
    const { userId: otherUserId } = req.params;
    const currentUserId = req.userId;
    const { page = 1, limit = 50 } = req.query;
    const skip = (page - 1) * limit;

    // Get messages between two users
    const messages = await Message.find({
      $or: [
        { senderId: currentUserId, recipientId: otherUserId },
        { senderId: otherUserId, recipientId: currentUserId },
      ],
    })
      .populate('senderId', 'name email')
      .populate('recipientId', 'name email')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit));

    // Mark messages as read (if recipient is current user)
    await Message.updateMany(
      { senderId: otherUserId, recipientId: currentUserId, read: false },
      { read: true }
    );

    const total = await Message.countDocuments({
      $or: [
        { senderId: currentUserId, recipientId: otherUserId },
        { senderId: otherUserId, recipientId: currentUserId },
      ],
    });

    res.status(200).json({
      success: true,
      messages: messages.reverse(), // Show oldest first
      pagination: {
        current: page,
        limit,
        total,
        pages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch chat history',
      error: error.message,
    });
  }
};

// Get Conversations List (all chats for current user)
export const getConversations = async (req, res) => {
  try {
    const userId = req.userId;

    // Get all unique conversations
    const conversations = await Message.aggregate([
      {
        $match: {
          $or: [{ senderId: userId }, { recipientId: userId }],
        },
      },
      {
        $sort: { createdAt: -1 },
      },
      {
        $group: {
          _id: {
            $cond: [
              { $eq: ['$senderId', userId] },
              '$recipientId',
              '$senderId',
            ],
          },
          lastMessage: { $first: '$text' },
          lastMessageTime: { $first: '$createdAt' },
          unreadCount: {
            $sum: {
              $cond: [
                {
                  $and: [
                    { $eq: ['$recipientId', userId] },
                    { $eq: ['$read', false] },
                  ],
                },
                1,
                0,
              ],
            },
          },
        },
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'userDetails',
        },
      },
      {
        $unwind: '$userDetails',
      },
      {
        $sort: { lastMessageTime: -1 },
      },
      {
        $project: {
          userId: '$_id',
          userName: '$userDetails.name',
          userEmail: '$userDetails.email',
          lastMessage: 1,
          lastMessageTime: 1,
          unreadCount: 1,
        },
      },
    ]);

    res.status(200).json({
      success: true,
      conversations,
      totalConversations: conversations.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch conversations',
      error: error.message,
    });
  }
};

// Get Unread Messages Count
export const getUnreadCount = async (req, res) => {
  try {
    const userId = req.userId;

    const unreadCount = await Message.countDocuments({
      recipientId: userId,
      read: false,
    });

    res.status(200).json({
      success: true,
      unreadCount,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch unread count',
      error: error.message,
    });
  }
};

// Delete Message (only sender can delete)
export const deleteMessage = async (req, res) => {
  try {
    const { messageId } = req.params;
    const userId = req.userId;

    const message = await Message.findById(messageId);

    if (!message) {
      return res.status(404).json({
        success: false,
        message: 'Message not found',
      });
    }

    // Check authorization
    if (message.senderId.toString() !== userId) {
      return res.status(403).json({
        success: false,
        message: 'You can only delete your own messages',
      });
    }

    await Message.findByIdAndDelete(messageId);

    res.status(200).json({
      success: true,
      message: 'Message deleted successfully',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to delete message',
      error: error.message,
    });
  }
};
