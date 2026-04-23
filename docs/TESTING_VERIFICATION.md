# Vibe App - Testing & Verification Plan (Phase 8)

## Overview
This document outlines the comprehensive testing strategy for the Vibe social media and interest-based matching application. The testing covers backend APIs, Flutter frontend, end-to-end user flows, and performance verification.

## Testing Environment Setup

### Prerequisites
- Node.js 18+ installed
- Flutter 3.0+ installed
- MongoDB 5.0+ installed and running
- Postman or similar API testing tool
- Android/iOS emulator or physical device

### Environment Configuration
```bash
# Backend setup
cd backend
npm install
cp .env.example .env  # Configure with proper values
npm start

# Frontend setup
cd frontend
flutter pub get
flutter run
```

## Backend API Testing

### Authentication APIs
**Base URL:** `http://localhost:5000/api/auth`

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "confirmPassword": "password123"
}
```
**Expected Response:** 201 Created
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": { "user": {...}, "token": "jwt_token" }
}
```

#### Login User
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```
**Expected Response:** 200 OK

#### Get Profile
```http
GET /api/auth/profile
Authorization: Bearer jwt_token
```
**Expected Response:** 200 OK

### Profile Management APIs
**Base URL:** `http://localhost:5000/api/profiles`

#### Create/Update Profile
```http
POST /api/profiles
Authorization: Bearer jwt_token
Content-Type: application/json

{
  "bio": "Software developer passionate about AI",
  "interests": ["Technology", "AI", "Programming"],
  "hobbies": ["Reading", "Gaming", "Hiking"],
  "location": "New York",
  "age": 25,
  "gender": "Male"
}
```

#### Get Profile
```http
GET /api/profiles/:userId
Authorization: Bearer jwt_token
```

### Posts APIs
**Base URL:** `http://localhost:5000/api/posts`

#### Create Post
```http
POST /api/posts
Authorization: Bearer jwt_token
Content-Type: application/json

{
  "content": "Excited to start my journey with Vibe!",
  "image": null
}
```

#### Get Feed
```http
GET /api/posts/feed?page=1&limit=10
Authorization: Bearer jwt_token
```

#### Like/Unlike Post
```http
POST /api/posts/:postId/like
Authorization: Bearer jwt_token
```

### Matching APIs
**Base URL:** `http://localhost:5000/api/matching`

#### Get Match Suggestions
```http
GET /api/matching/suggestions
Authorization: Bearer jwt_token
```

#### Calculate Match Score
```http
POST /api/matching/calculate
Authorization: Bearer jwt_token
Content-Type: application/json

{
  "userId": "target_user_id"
}
```

### Messaging APIs
**Base URL:** `http://localhost:5000/api/messages`

#### Send Message
```http
POST /api/messages/send
Authorization: Bearer jwt_token
Content-Type: application/json

{
  "receiverId": "target_user_id",
  "content": "Hello! How are you?",
  "messageType": "text"
}
```

#### Get Chat History
```http
GET /api/messages/history/target_user_id?page=1&limit=50
Authorization: Bearer jwt_token
```

#### Get Chat List
```http
GET /api/messages/chats
Authorization: Bearer jwt_token
```

### Notifications APIs
**Base URL:** `http://localhost:5000/api/notifications`

#### Get Notifications
```http
GET /api/notifications?page=1&limit=20
Authorization: Bearer jwt_token
```

#### Mark as Read
```http
PUT /api/notifications/notification_id/read
Authorization: Bearer jwt_token
```

## Flutter Frontend Testing

### Screen Navigation Testing
1. **Authentication Flow**
   - Launch app → Login screen
   - Register new user → Profile setup → Home screen
   - Login existing user → Home screen

2. **Bottom Navigation**
   - Feed tab → Posts feed with create post option
   - Matches tab → Swipe interface for matching
   - Messages tab → Chat list with unread indicators
   - Notifications tab → Notification list with mark as read
   - Profile tab → User profile with edit options

### User Interaction Testing
1. **Profile Management**
   - Complete profile setup with interests and hobbies
   - Edit profile information
   - Upload/change profile picture

2. **Posting**
   - Create text posts
   - View feed with pagination
   - Like/unlike posts
   - Add comments to posts

3. **Matching**
   - View match suggestions
   - Swipe left/right on profiles
   - View match compatibility scores

4. **Messaging**
   - Start conversation with matched user
   - Send/receive text messages
   - View chat history with pagination
   - Mark messages as read

5. **Notifications**
   - Receive notifications for new messages
   - Mark notifications as read
   - Delete notifications
   - View notification details

## End-to-End User Flows

### Complete User Journey
1. **User Registration & Setup**
   ```
   Register → Login → Complete Profile → View Feed
   ```

2. **Social Interaction Flow**
   ```
   View Feed → Create Post → Get Likes/Comments → Receive Notifications
   ```

3. **Matching & Connection Flow**
   ```
   View Matches → Swipe Right on Interest → Start Chat → Send Messages
   ```

4. **Complete Interaction Loop**
   ```
   User A: Register → Complete Profile → Create Posts
   User B: Register → Complete Profile → View Matches → Match with User A → Send Message
   User A: Receive Match Notification → Receive Message Notification → Reply
   ```

## Performance Testing

### API Response Times
- Authentication: < 500ms
- Profile operations: < 300ms
- Feed loading: < 1000ms
- Message sending: < 200ms
- Match calculation: < 500ms

### Flutter App Performance
- App launch time: < 3 seconds
- Screen transitions: < 200ms
- List scrolling: 60 FPS
- Image loading: < 2 seconds

### Database Performance
- Query execution: < 100ms for simple queries
- Aggregation pipelines: < 500ms
- Index usage verification
- Connection pooling efficiency

## Security Testing

### Authentication Security
- JWT token validation
- Password hashing verification
- Route protection testing
- Token expiration handling

### Input Validation
- SQL injection prevention
- XSS protection
- Input sanitization
- File upload restrictions

### API Security
- CORS configuration
- Rate limiting
- Error message sanitization
- Sensitive data exposure

## Error Handling Testing

### Network Errors
- Offline mode handling
- Timeout scenarios
- Retry mechanisms
- Graceful degradation

### Validation Errors
- Required field validation
- Data type validation
- Business rule validation
- User-friendly error messages

### System Errors
- Database connection failures
- Server errors
- Memory issues
- Disk space problems

## Automated Testing Setup

### Backend Testing
```bash
cd backend
npm test  # Run unit and integration tests
npm run test:e2e  # Run end-to-end API tests
```

### Frontend Testing
```bash
cd frontend
flutter test  # Run widget tests
flutter drive --target=test_driver/app.dart  # Run integration tests
```

## Testing Checklist

### Pre-Deployment Verification
- [ ] All API endpoints return correct responses
- [ ] Authentication flow works end-to-end
- [ ] Flutter app builds without errors
- [ ] All screens navigate correctly
- [ ] Database connections stable
- [ ] Error handling works properly
- [ ] Performance meets requirements
- [ ] Security measures in place

### Post-Deployment Monitoring
- [ ] User registration tracking
- [ ] Error logging and monitoring
- [ ] Performance metrics collection
- [ ] User feedback collection
- [ ] Bug reporting system active

## Testing Tools & Scripts

### API Testing Scripts
```bash
# Run all API tests
./scripts/test-apis.sh

# Load testing
./scripts/load-test.sh

# Security testing
./scripts/security-test.sh
```

### Flutter Testing Scripts
```bash
# Run all Flutter tests
./scripts/test-flutter.sh

# Generate test coverage
./scripts/coverage.sh
```

## Bug Tracking & Reporting

### Bug Report Template
```
Title: [Brief description]
Environment: [Backend/Frontend/Both]
Steps to Reproduce:
1. Step 1
2. Step 2
3. Step 3

Expected Result: [What should happen]
Actual Result: [What actually happens]
Severity: [Critical/High/Medium/Low]
Screenshots/Logs: [Attach if applicable]
```

### Testing Status Dashboard
- Total test cases: [X]
- Passed: [X]
- Failed: [X]
- Blocked: [X]
- Coverage: [X]%

## Conclusion

This comprehensive testing plan ensures the Vibe application meets all functional, performance, and security requirements. Regular execution of these tests will maintain application quality and user satisfaction.