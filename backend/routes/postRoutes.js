import express from 'express';
import {
  createPost,
  getFeed,
  getUserPosts,
  getPost,
  updatePost,
  deletePost,
  likePost,
  addComment,
  deleteComment,
} from '../controllers/postController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';

const router = express.Router();

// Protected routes
router.post('/create', authMiddleware, createPost);
router.put('/:postId/update', authMiddleware, updatePost);
router.delete('/:postId', authMiddleware, deletePost);
router.post('/:postId/like', authMiddleware, likePost);
router.post('/:postId/comment', authMiddleware, addComment);
router.delete('/:postId/comment/:commentId', authMiddleware, deleteComment);

// Public routes
router.get('/feed', getFeed);
router.get('/user/:userId', getUserPosts);
router.get('/:postId', getPost);

export default router;
