# Vibe API Documentation

## Base URL
```
http://localhost:5000/api
```

## Authentication
All API requests (except registration and login) require authentication via JWT token in the Authorization header:
```
Authorization: Bearer <jwt_token>
```

---

## Authentication Endpoints

### Register User
```http
POST /auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "confirmPassword": "password123"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "_id": "user_id",
      "name": "John Doe",
      "email": "john@example.com",
      "createdAt": "2024-01-01T00:00:00.000Z"
    },
    "token": "jwt_token_here"
  }
}
```

### Login User
```http
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "_id": "user_id",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "token": "jwt_token_here"
  }
}
```

### Get User Profile
```http
GET /auth/profile
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "_id": "user_id",
      "name": "John Doe",
      "email": "john@example.com",
      "profile": {
        "bio": "Software developer",
        "interests": ["Technology", "AI"],
        "hobbies": ["Reading", "Gaming"]
      }
    }
  }
}
```

---

## Profile Endpoints

### Create/Update Profile
```http
POST /profiles
Authorization: Bearer <token>
Content-Type: application/json

{
  "bio": "Passionate software developer",
  "interests": ["Technology", "AI", "Programming"],
  "hobbies": ["Reading", "Gaming", "Hiking"],
  "location": "New York",
  "age": 25,
  "gender": "Male"
}
```

**Response (201/200):**
```json
{
  "success": true,
  "message": "Profile created/updated successfully",
  "data": {
    "profile": {
      "_id": "profile_id",
      "userId": "user_id",
      "bio": "Passionate software developer",
      "interests": ["Technology", "AI", "Programming"],
      "hobbies": ["Reading", "Gaming", "Hiking"],
      "location": "New York",
      "age": 25,
      "gender": "Male"
    }
  }
}
```

### Get User Profile
```http
GET /profiles/:userId
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "profile": {
      "_id": "profile_id",
      "userId": "user_id",
      "bio": "Passionate software developer",
      "interests": ["Technology", "AI", "Programming"],
      "hobbies": ["Reading", "Gaming", "Hiking"],
      "location": "New York",
      "age": 25,
      "gender": "Male"
    }
  }
}
```

### Delete Profile
```http
DELETE /profiles
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Profile deleted successfully"
}
```

---

## Posts Endpoints

### Create Post
```http
POST /posts
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "Excited to start my Vibe journey!",
  "image": null
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Post created successfully",
  "data": {
    "post": {
      "_id": "post_id",
      "userId": "user_id",
      "content": "Excited to start my Vibe journey!",
      "image": null,
      "likes": [],
      "comments": [],
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

### Get Feed
```http
GET /posts/feed?page=1&limit=10
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "posts": [
      {
        "_id": "post_id",
        "userId": {
          "_id": "user_id",
          "name": "John Doe",
          "profilePicture": null
        },
        "content": "Excited to start my Vibe journey!",
        "image": null,
        "likes": ["user_id_1", "user_id_2"],
        "comments": [
          {
            "_id": "comment_id",
            "userId": {
              "_id": "user_id_1",
              "name": "Jane Smith"
            },
            "content": "Welcome to Vibe!",
            "createdAt": "2024-01-01T00:05:00.000Z"
          }
        ],
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "pagination": {
      "current": 1,
      "limit": 10,
      "total": 25,
      "pages": 3
    }
  }
}
```

### Like/Unlike Post
```http
POST /posts/:postId/like
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Post liked/unliked successfully",
  "data": {
    "liked": true,
    "likesCount": 15
  }
}
```

### Get Post Comments
```http
GET /posts/:postId/comments?page=1&limit=10
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "comments": [
      {
        "_id": "comment_id",
        "userId": {
          "_id": "user_id",
          "name": "Jane Smith"
        },
        "content": "Great post!",
        "createdAt": "2024-01-01T00:05:00.000Z"
      }
    ],
    "pagination": {
      "current": 1,
      "limit": 10,
      "total": 5,
      "pages": 1
    }
  }
}
```

### Add Comment
```http
POST /posts/:postId/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "This is amazing!"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Comment added successfully",
  "data": {
    "comment": {
      "_id": "comment_id",
      "userId": "user_id",
      "postId": "post_id",
      "content": "This is amazing!",
      "createdAt": "2024-01-01T00:10:00.000Z"
    }
  }
}
```

---

## Matching Endpoints

### Get Match Suggestions
```http
GET /matching/suggestions?page=1&limit=10
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "matches": [
      {
        "_id": "user_id",
        "name": "Jane Smith",
        "profile": {
          "bio": "AI enthusiast",
          "interests": ["Technology", "AI", "Machine Learning"],
          "hobbies": ["Reading", "Coding"],
          "location": "San Francisco",
          "age": 26,
          "gender": "Female"
        },
        "compatibilityScore": 85
      }
    ],
    "pagination": {
      "current": 1,
      "limit": 10,
      "total": 50,
      "pages": 5
    }
  }
}
```

### Calculate Match Score
```http
POST /matching/calculate
Authorization: Bearer <token>
Content-Type: application/json

{
  "userId": "target_user_id"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "compatibilityScore": 85,
    "breakdown": {
      "interestsMatch": 80,
      "hobbiesMatch": 90,
      "details": {
        "sharedInterests": ["Technology", "AI"],
        "sharedHobbies": ["Reading"]
      }
    }
  }
}
```

---

## Messaging Endpoints

### Send Message
```http
POST /messages/send
Authorization: Bearer <token>
Content-Type: application/json

{
  "receiverId": "target_user_id",
  "content": "Hello! How are you?",
  "messageType": "text"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "message": {
      "_id": "message_id",
      "senderId": {
        "_id": "sender_id",
        "username": "john_doe"
      },
      "receiverId": {
        "_id": "receiver_id",
        "username": "jane_smith"
      },
      "content": "Hello! How are you?",
      "messageType": "text",
      "isRead": false,
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

### Get Chat History
```http
GET /messages/history/:userId?page=1&limit=50
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "messages": [
      {
        "_id": "message_id",
        "senderId": {
          "_id": "sender_id",
          "username": "john_doe"
        },
        "receiverId": {
          "_id": "receiver_id",
          "username": "jane_smith"
        },
        "content": "Hello! How are you?",
        "messageType": "text",
        "isRead": true,
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "pagination": {
      "current": 1,
      "limit": 50,
      "total": 25,
      "pages": 1
    },
    "otherUser": {
      "_id": "receiver_id",
      "username": "jane_smith",
      "profilePicture": null
    }
  }
}
```

### Get Chat List
```http
GET /messages/chats
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "userId": "user_id_1",
      "username": "jane_smith",
      "profilePicture": null,
      "lastMessage": {
        "id": "message_id",
        "content": "Hello! How are you?",
        "messageType": "text",
        "createdAt": "2024-01-01T00:00:00.000Z",
        "isRead": false
      },
      "unreadCount": 2
    }
  ]
}
```

### Get Unread Count
```http
GET /messages/unread/count
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "unreadCount": 5
  }
}
```

### Mark Messages as Read
```http
PUT /messages/read/:userId
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Messages marked as read",
  "data": {
    "modifiedCount": 3
  }
}
```

---

## Notifications Endpoints

### Get Notifications
```http
GET /notifications?page=1&limit=20&type=message&isRead=false
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "_id": "notification_id",
        "userId": "user_id",
        "type": "message",
        "title": "New Message",
        "message": "You have a new message from John Doe",
        "relatedId": "message_id",
        "relatedType": "message",
        "isRead": false,
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    ],
    "pagination": {
      "current": 1,
      "limit": 20,
      "total": 15,
      "pages": 1
    }
  }
}
```

### Get Unread Count
```http
GET /notifications/unread/count
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "unreadCount": 3
  }
}
```

### Mark as Read
```http
PUT /notifications/:notificationId/read
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Notification marked as read",
  "data": {
    "notification": {
      "_id": "notification_id",
      "isRead": true
    }
  }
}
```

### Mark All as Read
```http
PUT /notifications/read/all
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "All notifications marked as read",
  "data": {
    "modifiedCount": 5
  }
}
```

### Delete Notification
```http
DELETE /notifications/:notificationId
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "message": "Notification deleted successfully"
}
```

---

## Error Responses

### Authentication Error (401)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Validation Error (400)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Email is required"
    }
  ]
}
```

### Not Found Error (404)
```json
{
  "success": false,
  "message": "Resource not found"
}
```

### Server Error (500)
```json
{
  "success": false,
  "message": "Internal server error"
}
```

---

## Rate Limiting
- API requests are limited to 100 requests per 15 minutes per IP
- Authentication endpoints: 5 requests per hour per IP

## Data Formats
- All dates are in ISO 8601 format (UTC)
- Pagination uses 1-based indexing
- Boolean values are true/false
- ObjectIds are MongoDB ObjectId strings

## WebSocket Support (Future)
Real-time messaging will be available via WebSocket connection:
```
ws://localhost:5000/ws?token=<jwt_token>
```

Events:
- `message:new` - New message received
- `notification:new` - New notification
- `user:online` - User came online
- `user:offline` - User went offline