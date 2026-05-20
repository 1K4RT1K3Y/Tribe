import ConnectionRequest from '../models/ConnectionRequest.js';
import User from '../models/User.js';
import Profile from '../models/Profile.js';

// Send Connection Request
export const sendConnectionRequest = async (req, res) => {
  try {
    const { receiverId } = req.body;
    const senderId = req.userId;

    // Validation
    if (!receiverId) {
      return res.status(400).json({
        success: false,
        message: 'Receiver ID is required',
      });
    }

    // Can't send request to self
    if (senderId === receiverId) {
      return res.status(400).json({
        success: false,
        message: 'Cannot send connection request to yourself',
      });
    }

    // Check if receiver exists
    const receiver = await User.findById(receiverId);
    if (!receiver) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    // Check if request already exists
    const existingRequest = await ConnectionRequest.findOne({
      $or: [
        { senderId, receiverId },
        { senderId: receiverId, receiverId: senderId },
      ],
    });

    if (existingRequest) {
      return res.status(400).json({
        success: false,
        message: 'Connection request already exists',
      });
    }

    // Create new connection request
    const connectionRequest = new ConnectionRequest({
      senderId,
      receiverId,
      status: 'pending',
    });

    await connectionRequest.save();

    res.status(201).json({
      success: true,
      message: 'Connection request sent successfully',
      connectionRequest,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to send connection request',
      error: error.message,
    });
  }
};

// Get Pending Connection Requests
export const getPendingRequests = async (req, res) => {
  try {
    const userId = req.userId;

    const requests = await ConnectionRequest.find({
      receiverId: userId,
      status: 'pending',
    })
      .populate('senderId', 'name email')
      .sort({ createdAt: -1 });

    // Get profile information for senders
    const requestsWithProfiles = await Promise.all(
      requests.map(async (request) => {
        const profile = await Profile.findOne({ userId: request.senderId._id });
        return {
          ...request.toObject(),
          senderProfile: profile,
        };
      })
    );

    res.status(200).json({
      success: true,
      message: 'Pending requests retrieved successfully',
      requests: requestsWithProfiles,
      totalRequests: requestsWithProfiles.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch pending requests',
      error: error.message,
    });
  }
};

// Accept Connection Request
export const acceptConnectionRequest = async (req, res) => {
  try {
    const { requestId } = req.body;
    const userId = req.userId;

    // Validation
    if (!requestId) {
      return res.status(400).json({
        success: false,
        message: 'Request ID is required',
      });
    }

    // Find the request
    const request = await ConnectionRequest.findById(requestId);
    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    // Verify the user is the receiver
    if (request.receiverId.toString() !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Unauthorized',
      });
    }

    // Update request status
    request.status = 'accepted';
    request.updatedAt = new Date();
    await request.save();

    res.status(200).json({
      success: true,
      message: 'Connection request accepted',
      connectionRequest: request,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to accept connection request',
      error: error.message,
    });
  }
};

// Reject Connection Request
export const rejectConnectionRequest = async (req, res) => {
  try {
    const { requestId } = req.body;
    const userId = req.userId;

    // Validation
    if (!requestId) {
      return res.status(400).json({
        success: false,
        message: 'Request ID is required',
      });
    }

    // Find the request
    const request = await ConnectionRequest.findById(requestId);
    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Request not found',
      });
    }

    // Verify the user is the receiver
    if (request.receiverId.toString() !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Unauthorized',
      });
    }

    // Update request status
    request.status = 'rejected';
    request.updatedAt = new Date();
    await request.save();

    res.status(200).json({
      success: true,
      message: 'Connection request rejected',
      connectionRequest: request,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to reject connection request',
      error: error.message,
    });
  }
};

// Get Connected Users (accepted requests)
export const getConnectedUsers = async (req, res) => {
  try {
    const userId = req.userId;

    const connections = await ConnectionRequest.find({
      $or: [
        { senderId: userId, status: 'accepted' },
        { receiverId: userId, status: 'accepted' },
      ],
    })
      .populate('senderId', 'name email')
      .populate('receiverId', 'name email')
      .sort({ updatedAt: -1 });

    // Extract the connected user IDs
    const connectedUsers = connections.map((conn) => {
      return conn.senderId._id.toString() === userId
        ? conn.receiverId
        : conn.senderId;
    });

    res.status(200).json({
      success: true,
      message: 'Connected users retrieved successfully',
      connectedUsers,
      totalConnections: connectedUsers.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to fetch connected users',
      error: error.message,
    });
  }
};
