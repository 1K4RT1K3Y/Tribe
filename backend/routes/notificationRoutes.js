import express from 'express';
import {
  getNotifications,
  getUnreadNotificationsCount,
  markAsRead,
  markAllAsRead,
  deleteNotification,
  deleteAllNotifications,
} from '../controllers/notificationController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.get('/', authMiddleware, getNotifications);
router.get('/unread/count', authMiddleware, getUnreadNotificationsCount);
router.put('/:notificationId/read', authMiddleware, markAsRead);
router.put('/read/all', authMiddleware, markAllAsRead);
router.delete('/:notificationId', authMiddleware, deleteNotification);
router.delete('/all', authMiddleware, deleteAllNotifications);

export default router;
