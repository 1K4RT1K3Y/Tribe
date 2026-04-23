# Phase 4: Posts Module - API Documentation

## Overview
This document describes all Post APIs for the Vibe backend.

## Base URL
```
http://localhost:5000/api/posts
```

## Endpoints

### 1. Create Post (Protected)
**POST** `/create`

Creates a new post.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Request Body:**
```json
{
  "content": "Just had amazing coffee at my favorite place! ☕",
  "image": "https://example.com/image.jpg"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Post created successfully",
  "post": {
    "_id": "507f1f77bcf86cd799439013",
    "userId": "507f1f77bcf86cd799439011",
    "content": "Just had amazing coffee",
    "image": null,
    "likes": [],
    "comments": [],
    "createdAt": "2024-04-23T10:30:00.000Z",
    "updatedAt": "2024-04-23T10:30:00.000Z"
  }
}
```

---

### 2. Get Feed (Public)
**GET** `/feed`

Retrieves paginated feed of all posts.

**Query Parameters:**
- `page` (optional): Page number (default: 1)
-  `limit` (optional): Posts per page (default: 10)

**Success Response (200):**
```json
{
  "success": true,
  "posts": [...],
  "pagination": {
    "current": 1,
    "limit": 10,
    "total": 50,
    "pages": 5
  }
}
```

---

### 3. Get User Posts (Public)
**GET** `/user/:userId`

Retrieves all posts by specific user.

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Posts per page (default: 10)

**Success Response (200):**
```json
{
  "success": true,
  "posts": [...],
  "pagination": {...}
}
```

---

### 4. Get Single Post (Public)
**GET** `/:postId`

Retrieves single post details with all comments.

**Success Response (200):**
```json
{
  "success": true,
  "post": {...}
}
```

---

### 5. Update Post (Protected)
**PUT** `/:postId/update`

Edits post content or image.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Request Body:**
```json
{
  "content": "Updated post content",
  "image": "https://example.com/new-image.jpg"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Post updated successfully",
  "post": {...}
}
```

---

### 6. Delete Post (Protected)
**DELETE** `/:postId`

Deletes post (owner only).

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Post deleted successfully"
}
```

---

### 7. Like Post (Protected)
**POST** `/:postId/like`

Toggles like on a post.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Post liked",
  "post": {
    "likes": ["userId1", "userId2", "userId3"]
  }
}
```

---

### 8. Add Comment (Protected)
**POST** `/:postId/comment`

Adds comment to a post.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Request Body:**
```json
{
  "text": "This is amazing!"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Comment added successfully",
  "post": {
    "comments": [
      {
        "_id": "com123",
        "userId": "user123",
        "text": "This is amazing!",
        "createdAt": "2024-04-23T10:35:00.000Z"
      }
    ]
  }
}
```

---

### 9. Delete Comment (Protected)
**DELETE** `/:postId/comment/:commentId`

Deletes comment (owner only).

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Comment deleted successfully",
  "post": {...}
}
```

---

## Flutter Integration

```dart
// Create post
await PostService.createPost(
  content: 'Hello world!',
  image: null,
)

// Get feed
await PostService.getFeed(page: 1, limit: 10)

// Get user posts
await PostService.getUserPosts(userId, page: 1)

// Like post
await PostService.likePost(postId)

// Add comment
await PostService.addComment(
  postId: postId,
  text: 'Great post!',
)

// Delete comment
await PostService.deleteComment(
  postId: postId,
  commentId: commentId,
)
```

---

**Last Updated:** Phase 4 - Posts Module
