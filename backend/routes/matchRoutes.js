import express from 'express';
import {
  getSuggestedUsers,
  getMatchesByInterest,
  getCompatibilityScore,
  getPopularInterests,
} from '../controllers/matchController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.get('/suggestions', authMiddleware, getSuggestedUsers);
router.get('/by-interest', authMiddleware, getMatchesByInterest);
router.get('/compatibility/:targetUserId', authMiddleware, getCompatibilityScore);

// Public routes
router.get('/interests/popular', getPopularInterests);

export default router;
