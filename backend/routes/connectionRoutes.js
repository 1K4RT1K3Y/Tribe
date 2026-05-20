import express from 'express';
import {
  sendConnectionRequest,
  getPendingRequests,
  acceptConnectionRequest,
  rejectConnectionRequest,
  getConnectedUsers,
} from '../controllers/connectionController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.post('/send', authMiddleware, sendConnectionRequest);
router.get('/pending', authMiddleware, getPendingRequests);
router.post('/accept', authMiddleware, acceptConnectionRequest);
router.post('/reject', authMiddleware, rejectConnectionRequest);
router.get('/connected-users', authMiddleware, getConnectedUsers);

export default router;
