# Phase 3: Profile Module - API Documentation

## Overview
This document describes all Profile APIs for the Vibe backend.

## Base URL
```
http://localhost:5000/api/profiles
```

## Endpoints

### 1. Create Profile (Protected)
**POST** `/create`

Creates a new profile for authenticated user.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Request Body:**
```json
{
  "bio": "I love traveling and meeting new people",
  "interests": ["Travel", "Photography", "Music"],
  "hobbies": ["Hiking", "Cooking", "Reading"],
  "age": 25,
  "location": "San Francisco, USA"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "Profile created successfully",
  "profile": {
    "_id": "507f1f77bcf86cd799439012",
    "userId": "507f1f77bcf86cd799439011",
    "bio": "I love traveling and meeting new people",
    "interests": ["Travel", "Photography", "Music"],
    "hobbies": ["Hiking", "Cooking", "Reading"],
    "age": 25,
    "location": "San Francisco, USA",
    "profileImage": null,
    "verified": false,
    "createdAt": "2024-04-23T10:30:00.000Z",
    "updatedAt": "2024-04-23T10:30:00.000Z"
  }
}
```

---

### 2. Get My Profile (Protected)
**GET** `/me`

Retrieves authenticated user's profile.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "profile": {
    "_id": "507f1f77bcf86cd799439012",
    "userId": "507f1f77bcf86cd799439011",
    "bio": "I love traveling and meeting new people",
    "interests": ["Travel", "Photography", "Music"],
    "hobbies": ["Hiking", "Cooking", "Reading"],
    "age": 25,
    "location": "San Francisco, USA",
    "profileImage": null,
    "verified": false,
    "createdAt": "2024-04-23T10:30:00.000Z",
    "updatedAt": "2024-04-23T10:30:00.000Z"
  }
}
```

---

### 3. Get User Profile (Public)
**GET** `/:userId`

Retrieves any user's profile (public).

**URL Parameters:**
- `userId`: User ID (ObjectId)

**Success Response (200):**
```json
{
  "success": true,
  "profile": {
    "_id": "507f1f77bcf86cd799439012",
    "userId": "507f1f77bcf86cd799439011",
    "bio": "I love traveling and meeting new people",
    "interests": ["Travel", "Photography", "Music"],
    "hobbies": ["Hiking", "Cooking", "Reading"],
    "age": 25,
    "location": "San Francisco, USA",
    "profileImage": null,
    "verified": false,
    "createdAt": "2024-04-23T10:30:00.000Z",
    "updatedAt": "2024-04-23T10:30:00.000Z"
  }
}
```

---

### 4. Update Profile (Protected)
**PUT** `/update`

Updates authenticated user's profile.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Request Body (All fields optional):**
```json
{
  "bio": "Updated bio",
  "interests": ["Travel", "Photography", "Music", "Art"],
  "hobbies": ["Hiking", "Cooking"],
  "age": 26,
  "location": "New York, USA",
  "profileImage": "https://example.com/image.jpg"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "profile": {
    "_id": "507f1f77bcf86cd799439012",
    "userId": "507f1f77bcf86cd799439011",
    "bio": "Updated bio",
    "interests": ["Travel", "Photography", "Music", "Art"],
    "hobbies": ["Hiking", "Cooking"],
    "age": 26,
    "location": "New York, USA",
    "profileImage": "https://example.com/image.jpg",
    "verified": false,
    "createdAt": "2024-04-23T10:30:00.000Z",
    "updatedAt": "2024-04-23T11:45:00.000Z"
  }
}
```

---

### 5. Delete Profile (Protected)
**DELETE** `/delete`

Deletes authenticated user's profile.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Profile deleted successfully"
}
```

---

## Validation Rules

- **Bio**: Max 500 characters
- **Interests**: Max 20 items, max length per item
- **Hobbies**: Max 20 items, max length per item
- **Age**: 13-120 years
- **Location**: Free text, max 100 characters

---

## Flutter Integration

### ProfileService Methods

```dart
// Create profile
await ProfileService.createProfile(
  bio: 'I love traveling',
  interests: ['Travel', 'Art'],
  hobbies: ['Hiking', 'Reading'],
  age: 25,
  location: 'San Francisco, USA',
)

// Get my profile
await ProfileService.getMyProfile()

// Get other user's profile
await ProfileService.getUserProfile(userId)

// Update profile
await ProfileService.updateProfile(
  bio: 'Updated bio',
  interests: ['Travel', 'Art', 'Music'],
  age: 26,
)

// Delete profile
await ProfileService.deleteProfile()
```

---

## Testing

### Test Create Profile
```
POST http://localhost:5000/api/profiles/create
Headers: Authorization: Bearer {token}
{
  "bio": "Test bio",
  "interests": ["Sports", "Music"],
  "hobbies": ["Gaming", "Reading"],
  "age": 25,
  "location": "Test City"
}
```

### Test Get My Profile
```
GET http://localhost:5000/api/profiles/me
Headers: Authorization: Bearer {token}
```

### Test Get User Profile
```
GET http://localhost:5000/api/profiles/{userId}
```

### Test Update Profile
```
PUT http://localhost:5000/api/profiles/update
Headers: Authorization: Bearer {token}
{
  "bio": "Updated test bio",
  "interests": ["Sports", "Music", "Art"]
}
```

---

**Last Updated:** Phase 3 - Profile Module
