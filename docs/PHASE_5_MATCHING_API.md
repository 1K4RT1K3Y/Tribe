# Phase 5: Vibe Matching Module - API Documentation

## Overview
This document describes all Vibe Matching APIs for the Vibe backend.

## Base URL
```
http://localhost:5000/api/matches
```

## Matching Algorithm

The matching algorithm is based on **shared interests and hobbies** with a simple score calculation:

```
Match Score = (Common Interests / User's Total Interests) * 50 +
              (Common Hobbies / User's Total Hobbies) * 50

Score Range: 0-100%
```

**Example:**
- User A has interests: [Travel, Music, Sports, Art] (4 total)
- User B has interests: [Travel, Music, Photography] (3 total)
- Common interests: [Travel, Music] (2 matches)
- Interest Score: (2/4) * 50 = 25%

Matches with score > 0 are returned (at least 1 common interest/hobby).

---

## Endpoints

### 1. Get Suggested Users (Protected)
**GET** `/suggestions`

Returns top matched users based on shared interests and hobbies.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Query Parameters:**
- `limit` (optional): Number of suggestions (default: 10, max: 50)

**Success Response (200):**
```json
{
  "success": true,
  "matches": [
    {
      "userId": "507f1f77bcf86cd799439012",
      "userName": "Sarah",
      "userEmail": "sarah@example.com",
      "bio": "Love traveling and photography",
      "interests": ["Travel", "Photography", "Music"],
      "hobbies": ["Hiking", "Reading"],
      "age": 26,
      "location": "San Francisco, CA",
      "profileImage": null,
      "verified": false,
      "matchScore": 75,
      "commonInterests": 2,
      "commonHobbies": 1
    },
    {
      "userId": "507f1f77bcf86cd799439013",
      "userName": "Emma",
      "userEmail": "emma@example.com",
      "bio": "Adventure seeker",
      "interests": ["Travel", "Sports", "Food"],
      "hobbies": ["Camping", "Running"],
      "age": 24,
      "location": "New York, NY",
      "profileImage": null,
      "verified": true,
      "matchScore": 50,
      "commonInterests": 1,
      "commonHobbies": 0
    }
  ],
  "totalMatches": 2,
  "message": "Found 2 vibe matches for you!"
}
```

---

### 2. Get Matches by Interest (Protected)
**GET** `/by-interest`

Finds users with a specific shared interest.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Query Parameters:**
- `interest` (required): Interest to filter by
- `limit` (optional): Number of results (default: 10)

**Example Request:**
```
GET /api/matches/by-interest?interest=Travel&limit=15
```

**Success Response (200):**
```json
{
  "success": true,
  "matches": [
    {
      "userId": "507f1f77bcf86cd799439012",
      "userName": "Sarah",
      "userEmail": "sarah@example.com",
      "bio": "Love traveling and photography",
      "interests": ["Travel", "Photography", "Music"],
      "hobbies": ["Hiking", "Reading"],
      "age": 26,
      "location": "San Francisco, CA",
      "profileImage": null,
      "verified": false,
      "sharedInterest": "Travel"
    }
  ],
  "totalMatches": 1
}
```

---

### 3. Get Compatibility Score (Protected)
**GET** `/compatibility/:targetUserId`

Calculates detailed compatibility between authenticated user and target user.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**URL Parameters:**
- `targetUserId`: User ID to compare with

**Success Response (200):**
```json
{
  "success": true,
  "userId": "507f1f77bcf86cd799439012",
  "score": 75,
  "commonInterests": 2,
  "commonHobbies": 1
}
```

---

### 4. Get Popular Interests (Public)
**GET** `/interests/popular`

Returns trending interests across all users (good for discovery).

**Success Response (200):**
```json
{
  "success": true,
  "interests": [
    {
      "interest": "Travel",
      "userCount": 156
    },
    {
      "interest": "Photography",
      "userCount": 142
    },
    {
      "interest": "Music",
      "userCount": 138
    },
    {
      "interest": "Sports",
      "userCount": 125
    },
    {
      "interest": "Reading",
      "userCount": 112
    }
  ]
}
```

---

## Flutter Integration

```dart
// Get suggested matches
final result = await MatchService.getSuggestedUsers(limit: 10);
if (result['success']) {
  final matches = result['matches']; // List<Match>
}

// Get matches by interest
final result = await MatchService.getMatchesByInterest(
  interest: 'Travel',
  limit: 10,
);

// Get compatibility score
final result = await MatchService.getCompatibilityScore(targetUserId);
if (result['success']) {
  final score = result['score']; // int
  final commonInterests = result['commonInterests']; // int
}

// Get popular interests
final result = await MatchService.getPopularInterests();
if (result['success']) {
  final interests = result['interests']; // List of popular interests
}
```

---

## Matching Strategy

### Why Simple Scoring Works
1. **Transparency**: Users see exactly why they matched
2. **Performance**: Fast calculations, scales well
3. **User-Friendly**: Easy to understand for end-users
4. **Modular**: Can upgrade to AI later without breaking this

### Future Enhancements (Phase 2)
- Personality compatibility (Myers-Briggs type)
- Location-based matching
- Age preference matching
- Activity compatibility
- Machine learning based recommendations

---

## Testing

### Test Get Suggestions
```
GET http://localhost:5000/api/matches/suggestions?limit=5
Headers: Authorization: Bearer {token}
```

### Test Matches by Interest
```
GET http://localhost:5000/api/matches/by-interest?interest=Travel&limit=10
Headers: Authorization: Bearer {token}
```

### Test Compatibility
```
GET http://localhost:5000/api/matches/compatibility/{targetUserId}
Headers: Authorization: Bearer {token}
```

### Test Popular Interests
```
GET http://localhost:5000/api/matches/interests/popular
```

---

## Data Flow

```
User A: [Travel, Music, Sports] interests
                    ↓
          [Match Algorithm]
                    ↓
User B: [Travel, Photography]
User C: [Music, Art, Sports]
User D: [Photography, Travel, Music]
                    ↓
         [Score Calculation]
                    ↓
Results: User D (2/3 = 66.7%) > User B (1/3 = 33%) > User C (2/3 = 66.7%)
```

---

**Last Updated:** Phase 5 - Vibe Matching Module
