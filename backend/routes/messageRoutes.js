import express from 'express';
import {
  sendMessage,
  getChatHistory,
  getChatList,
  getUnreadCount,
  markMessagesAsRead,
  deleteMessage,
} from '../controllers/messageController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// All routes require authentication
router.use(authMiddleware);

// Send a message
router.post('/send', sendMessage);

// Get chat history with a specific user
router.get('/history/:userId', getChatHistory);

// Get user's chat list (recent conversations)
router.get('/chats', getChatList);

// Get unread messages count
router.get('/unread/count', getUnreadCount);

// Mark messages from a user as read
router.put('/read/:userId', markMessagesAsRead);

// Delete a message (only sender can delete)
router.delete('/:messageId', deleteMessage);

export default router;
