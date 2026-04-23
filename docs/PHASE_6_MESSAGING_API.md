# Phase 6: Messaging - API Documentation

## Overview

This document describes all Messaging APIs for the Vibe backend.

## Base URL

```
http://localhost:5000/api/messages
```

## Endpoints

### 1. Send Message (Protected)

**POST** `/send`

Sends a message to another user.

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Request Body:**

```json
{
  "recipientId": "507f1f77bcf86cd799439011",
  "text": "Hey! How are you doing?",
  "image": "https://example.com/image.jpg"
}
```

**Success Response (201):**

```json
{
  "success": true,
  "message": "Message sent successfully",
  "data": {
    "_id": "507f1f77bcf86cd799439013",
    "senderId": {
      "_id": "507f1f77bcf86cd799439012",
      "name": "John Doe",
      "email": "john@example.com"
    },
    "recipientId": {
      "_id": "507f1f77bcf86cd799439011",
      "name": "Sarah Johnson",
      "email": "sarah@example.com"
    },
    "text": "Hey! How are you doing?",
    "image": null,
    "read": false,
    "createdAt": "2024-04-23T10:30:00.000Z"
  }
}
```

**Validation:**

- `recipientId` and `text` are required
- Recipient must exist
- Cannot send message to yourself

---

### 2. Get Chat History (Protected)

**GET** `/history/:userId`

Retrieves message history between current user and specified user.

**URL Parameters:**

- `userId`: Other user's ID

**Query Parameters:**

- `page` (optional): Page number (default: 1)
- `limit` (optional): Messages per page (default: 50)

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
```

**Success Response (200):**

```json
{
  "success": true,
  "messages": [
    {
      "_id": "507f1f77bcf86cd799439013",
      "senderId": {
        "_id": "507f1f77bcf86cd799439012",
        "name": "John Doe",
        "email": "john@example.com"
      },
      "recipientId": {
        "_id": "507f1f77bcf86cd799439011",
        "name": "Sarah Johnson",
        "email": "sarah@example.com"
      },
      "text": "Hey! How are you doing?",
      "image": null,
      "read": true,
      "createdAt": "2024-04-23T10:30:00.000Z"
    }
  ],
  "pagination": {
    "current": 1,
    "limit": 50,
    "total": 25,
    "pages": 1
  }
}
```

**Features:**

- Automatically marks incoming messages as read
- Returns messages in chronological order (oldest first)
- Pagination support

---

### 3. Get Conversations List (Protected)

**GET** `/conversations`

Retrieves list of all conversations with last message and unread count.

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
```

**Success Response (200):**

```json
{
  "success": true,
  "conversations": [
    {
      "userId": "507f1f77bcf86cd799439011",
      "userName": "Sarah Johnson",
      "userEmail": "sarah@example.com",
      "lastMessage": "That sounds great!",
      "lastMessageTime": "2024-04-23T15:45:00.000Z",
      "unreadCount": 2
    },
    {
      "userId": "507f1f77bcf86cd799439014",
      "userName": "Mike Chen",
      "userEmail": "mike@example.com",
      "lastMessage": "See you tomorrow!",
      "lastMessageTime": "2024-04-23T14:20:00.000Z",
      "unreadCount": 0
    }
  ],
  "totalConversations": 2
}
```

**Features:**

- Sorted by most recent message
- Shows unread message count
- Shows last message preview

---

### 4. Get Unread Messages Count (Protected)

**GET** `/unread/count`

Retrieves count of unread messages.

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
```

**Success Response (200):**

```json
{
  "success": true,
  "unreadCount": 5
}
```

---

### 5. Delete Message (Protected)

**DELETE** `/:messageId`

Deletes a specific message (sender only).

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Message deleted successfully"
}
```

**Authorization:**

- Only the sender can delete their own messages

---

## Message Schema

```javascript
{
  senderId: ObjectId,        // User sending message
  recipientId: ObjectId,     // User receiving message
  text: String,              // Message content (max 1000 chars)
  image: String,             // Optional image URL
  read: Boolean,             // Read status (auto-marked on fetch)
  createdAt: Date            // Timestamp
}
```

---

## Features

### Automatic Read Status

- Messages are automatically marked as read when chat history is fetched
- Only marks incoming messages as read (recipientId = current user)
- Helps track unread conversations

### Pagination

- Default 50 messages per page
- Can adjust with `limit` query parameter
- Useful for loading chat incrementally

### Conversation Grouping

- Combines messages between two users
- Shows unread count per conversation
- Sorted by most recent activity

---

## Error Responses

### Missing Required Fields (400)

```json
{
  "success": false,
  "message": "Recipient ID and message text are required"
}
```

### Recipient Not Found (404)

```json
{
  "success": false,
  "message": "Recipient not found"
}
```

### Cannot Message Self (400)

```json
{
  "success": false,
  "message": "Cannot send message to yourself"
}
```

### Unauthorized Delete (403)

```json
{
  "success": false,
  "message": "You can only delete your own messages"
}
```

---

## Future Enhancements

- **Real-time Chat**: Upgrade from REST to WebSocket (Socket.io)
- **Typing Indicators**: Show when other user is typing
- **Read Receipts**: Show when message is read
- **File Sharing**: Support images, documents, etc.
- **Message Reactions**: Emoji reactions to messages
- **Message Search**: Search within conversations
- **Group Chats**: Support multiple users in one chat

---

## Usage Flow

1. **Send Message**

   ```
   POST /send
   Body: { recipientId, text }
   ```

2. **Get Conversations**

   ```
   GET /conversations
   ```

3. **Open Conversation**

   ```
   GET /history/{userId}
   Messages auto-marked as read
   ```

4. **Check Unread**
   ```
   GET /unread/count
   ```
