import express from 'express';
import {
  sendMessage,
  getChatHistory,
  getConversations,
  getUnreadCount,
  deleteMessage,
} from '../controllers/messageController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.post('/send', authMiddleware, sendMessage);
router.get('/history/:userId', authMiddleware, getChatHistory);
router.get('/conversations', authMiddleware, getConversations);
router.get('/unread/count', authMiddleware, getUnreadCount);
router.delete('/:messageId', authMiddleware, deleteMessage);

export default router;
