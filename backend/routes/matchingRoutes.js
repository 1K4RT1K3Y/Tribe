import express from 'express';
import {
  getSuggestedUsers,
  getUserProfileDetails,
  getAllUsersWithMatchScores,
} from '../controllers/matchingController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.get('/suggestions', authMiddleware, getSuggestedUsers);
router.get('/debug/all-scores', authMiddleware, getAllUsersWithMatchScores);

// Public route (can view any user's profile)
router.get('/:userId', getUserProfileDetails);

export default router;
