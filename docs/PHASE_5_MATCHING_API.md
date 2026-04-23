# Phase 5: Vibe Matching - API Documentation

## Overview

This document describes all Matching APIs for the Vibe backend.

## Base URL

```
http://localhost:5000/api/matching
```

## Endpoints

### 1. Get Suggested Users (Protected)

**GET** `/suggestions`

Retrieves list of suggested users based on common interests.

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**

```json
{
  "success": true,
  "message": "Suggested users retrieved successfully",
  "suggestedUsers": [
    {
      "userId": "507f1f77bcf86cd799439011",
      "userName": "Sarah Johnson",
      "userEmail": "sarah@example.com",
      "bio": "I love traveling and photography",
      "interests": ["Travel", "Photography", "Music"],
      "hobbies": ["Hiking", "Cooking"],
      "age": 25,
      "location": "San Francisco, USA",
      "profileImage": null,
      "matchScore": 3,
      "commonInterests": ["Travel", "Photography", "Music"]
    }
  ],
  "totalSuggestions": 5
}
```

**Match Score Calculation:**

- Match Score = Number of common interests between users
- Only users with at least 1 common interest are shown
- Results sorted by match score (highest first)
- Maximum 10 suggestions returned

---

### 2. Get User Profile Details (Public)

**GET** `/:userId`

Retrieves detailed profile of a specific user.

**URL Parameters:**

- `userId`: User ID (ObjectId)

**Success Response (200):**

```json
{
  "success": true,
  "profile": {
    "userId": "507f1f77bcf86cd799439011",
    "userName": "Sarah Johnson",
    "userEmail": "sarah@example.com",
    "bio": "I love traveling and photography",
    "interests": ["Travel", "Photography", "Music"],
    "hobbies": ["Hiking", "Cooking"],
    "age": 25,
    "location": "San Francisco, USA",
    "profileImage": null,
    "verified": false,
    "createdAt": "2024-04-23T10:30:00.000Z"
  }
}
```

---

### 3. Get All Users with Match Scores (Debug Only - Protected)

**GET** `/debug/all-scores`

Retrieves all users with their match scores (for debugging).

**Headers:**

```
Authorization: Bearer {JWT_TOKEN}
```

**Success Response (200):**

```json
{
  "success": true,
  "yourInterests": ["Travel", "Photography", "Music"],
  "usersWithScores": [
    {
      "userId": "507f1f77bcf86cd799439011",
      "userName": "Sarah Johnson",
      "interests": ["Travel", "Photography", "Music"],
      "matchScore": 3
    }
  ]
}
```

---

## Algorithm Details

### Vibe Matching Logic

1. **Get Current User's Interests**
   - Fetch user's profile from database
   - Extract interests array

2. **Compare with Other Users**
   - Get all other users' profiles
   - Calculate common interests for each user

3. **Calculate Match Score**

   ```
   commonInterests = userInterests.filter(interest =>
     otherUserInterests.includes(interest)
   )
   matchScore = commonInterests.length
   ```

4. **Filter & Sort**
   - Filter users with matchScore > 0
   - Sort by matchScore (descending)
   - Return top 10 suggestions

### Example

```
Your Interests: [Travel, Photography, Music, Cooking]

User A Interests: [Travel, Photography, Music]
Common: [Travel, Photography, Music] = Score: 3

User B Interests: [Travel, Cooking, Gaming]
Common: [Travel, Cooking] = Score: 2

User C Interests: [Art, Reading]
Common: [] = Score: 0 (Not shown)

Result Order: User A (3), User B (2)
```

---

## Use Cases

### Basic Vibe Matching

1. User completes profile with interests
2. Frontend calls `/suggestions`
3. Backend calculates match scores
4. Frontend displays suggested users
5. User can view each profile and message them

### Future Enhancements

- Add hobbies-based matching
- Add location-based matching
- Add AI-based smart matching
- Add connection history tracking
- Add "skip" functionality

---

## Error Responses

### Profile Not Found (404)

```json
{
  "success": false,
  "message": "Your profile not found. Please complete your profile first."
}
```

### User Not Found (404)

```json
{
  "success": false,
  "message": "User profile not found"
}
```

---

## Notes

- At least 1 common interest required for suggestion
- Current user excluded from suggestions
- Already matched users may be included (handle in frontend)
- Scoring is simple for MVP (can be enhanced later)
