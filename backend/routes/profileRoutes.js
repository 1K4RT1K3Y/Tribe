import express from 'express';
import {
  createProfile,
  getUserProfile,
  getMyProfile,
  updateProfile,
  deleteProfile,
} from '../controllers/profileController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.post('/create', authMiddleware, createProfile);
router.get('/me', authMiddleware, getMyProfile);
router.put('/update', authMiddleware, updateProfile);
router.delete('/delete', authMiddleware, deleteProfile);

// Public routes
router.get('/:userId', getUserProfile);

export default router;
