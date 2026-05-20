# Tribe App - Integration Testing Checklist

## Pre-Test Requirements
- Backend running on `http://localhost:5000`
- Frontend connected to backend API
- MongoDB database connected and running

---

## Test Suite 1: Authentication & Registration ✅

### Test 1.1: Valid Registration
- [ ] Enter name: "John Doe"
- [ ] Enter email: "john@example.com"
- [ ] Enter password: "SecurePass123"
- [ ] Confirm password: "SecurePass123"
- [ ] Click Register
- **Expected**: Auto-login and navigate to ProfileSetupScreen

### Test 1.2: Password Strength Validation
- [ ] Try password: "weak" (less than 8 chars)
- **Expected**: Error: "Password must be at least 8 characters"
- [ ] Try password: "NoNumbers" (no numbers)
- **Expected**: Error: "Password must contain at least one number"
- [ ] Try password: "nonumbersupper" (no uppercase)
- **Expected**: Error: "Password must contain at least one uppercase letter"

### Test 1.3: Email Validation
- [ ] Try email: "invalidemail"
- **Expected**: Error: "Please provide a valid email address"
- [ ] Try duplicate registration with same email
- **Expected**: Error: "Email already registered"

### Test 1.4: Required Fields
- [ ] Leave name empty and submit
- **Expected**: Error: "Please provide all required fields"

---

## Test Suite 2: Profile Setup ✅

### Test 2.1: Complete Profile
- [ ] Enter Bio: "I love traveling and photography"
- [ ] Enter Age: 25
- [ ] Enter Location: "New York, USA"
- [ ] Enter Occupation: "Software Engineer"
- [ ] Select Gender: "Male"
- [ ] Select Relationship Status: "Single"
- [ ] Add Interests: ["Travel", "Photography", "Coding", "Music"]
- [ ] Add Hobbies: ["Hiking", "Reading"]
- [ ] Click Save
- **Expected**: Profile saved, marker set as complete

### Test 2.2: Profile Validation
- [ ] Try Age: 5
- **Expected**: Error (validation on frontend/backend - age < 13)
- [ ] Try Bio: [1000+ characters]
- **Expected**: Error: "Bio cannot exceed 500 characters"
- [ ] Try add 25 interests
- **Expected**: Error: "Maximum 20 interests allowed"

### Test 2.3: Skip & Edit Later
- [ ] Click Skip on profile setup
- **Expected**: Navigate to home/feed (incomplete profile)
- [ ] Click Edit Profile button
- **Expected**: Load existing profile data for editing

---

## Test Suite 3: Discover & Matching ✅

### Test 3.1: View Suggestions
- [ ] Navigate to Discover/Matching tab
- [ ] Create at least 2 other users with 4+ shared interests
- [ ] View your profile
- **Expected**: See suggested users with matching algorithm

### Test 3.2: Search Users
- [ ] Type in search bar: "John"
- **Expected**: Results filtered showing matching users
- [ ] Try empty search
- **Expected**: Error: "Search query is required" (or show all)

### Test 3.3: Send Connection Request
- [ ] Click on suggested user profile
- [ ] Click "Send Connection Request"
- **Expected**: Button changes or shows "Request Sent"
- [ ] Try sending to same user again
- **Expected**: Error: "Connection request already exists"

### Test 3.4: Match Score Display
- [ ] View suggested user
- **Expected**: Shows common interests and match score
- [ ] Verify only users with 4+ common interests shown

---

## Test Suite 4: Connection Requests (Notifications) ✅

### Test 4.1: Receive & Accept Request
- [ ] Switch to receiving user account
- [ ] Navigate to Notifications tab
- [ ] View incoming connection request
- **Expected**: Show sender profile with Accept/Decline buttons
- [ ] Click Accept
- **Expected**: Request removed, connection established

### Test 4.2: Receive & Decline Request
- [ ] View another incoming request
- [ ] Click Decline
- **Expected**: Request removed from list

### Test 4.3: Self-Connection Prevention
- [ ] Try sending request to own profile
- **Expected**: Error: "Cannot send connection request to yourself"

---

## Test Suite 5: Messaging ✅

### Test 5.1: Send Message
- [ ] Navigate to Messages tab
- [ ] Open chat with connected user
- [ ] Type message: "Hello!"
- [ ] Click Send
- **Expected**: Message appears in chat, marked with timestamp

### Test 5.2: Message Validation
- [ ] Try sending empty message
- **Expected**: Error: "Message content cannot be empty"
- [ ] Try message > 1000 characters
- **Expected**: Error: "Message cannot exceed 1000 characters"

### Test 5.3: Chat History
- [ ] Send 5 messages
- [ ] Scroll up in chat
- **Expected**: Load previous messages (pagination)

### Test 5.4: Mark as Read
- [ ] Receive message from another user
- [ ] Message appears with unread indicator
- [ ] Open chat
- **Expected**: Message marked as read

### Test 5.5: Chat List
- [ ] Navigate to Messages tab
- [ ] View list of all conversations
- **Expected**: Shows recent conversations with preview

---

## Test Suite 6: Posts & Feed ✅

### Test 6.1: Create Post
- [ ] Navigate to Feed tab
- [ ] Click Floating Action Button (add icon)
- [ ] Type post content: "Just finished a great project!"
- [ ] Click Post
- **Expected**: Post appears at top of feed

### Test 6.2: Post Validation
- [ ] Try posting empty content
- **Expected**: Error: "Post content cannot be empty"
- [ ] Try post > 1000 characters
- **Expected**: Error: "Post content cannot exceed 1000 characters"

### Test 6.3: Like Post
- [ ] View post in feed
- [ ] Click like button
- **Expected**: Like count increases, button highlights
- [ ] Click again
- **Expected**: Unlike, count decreases

### Test 6.4: Add Comment
- [ ] Click comment icon on post
- [ ] Type comment: "Great job!"
- [ ] Submit
- **Expected**: Comment appears below post
- [ ] Try empty comment
- **Expected**: Error

### Test 6.5: Feed Pagination
- [ ] Create 15+ posts
- [ ] Scroll to bottom of feed
- **Expected**: Load more posts

### Test 6.6: Delete Post
- [ ] Find your own post
- [ ] Click delete (if available)
- **Expected**: Post removed from feed
- [ ] Try deleting another user's post
- **Expected**: Authorization error

---

## Test Suite 7: Error Handling & Edge Cases ✅

### Test 7.1: Network Errors
- [ ] Stop backend server
- [ ] Try any action (send message, create post, etc.)
- **Expected**: Graceful error message

### Test 7.2: Authentication
- [ ] Log out
- [ ] Try accessing protected screens
- **Expected**: Redirected to login

### Test 7.3: Invalid Data
- [ ] Manually edit localStorage/SharedPreferences
- [ ] Try invalid token
- **Expected**: Error: "Unauthorized" or "Not authenticated"

### Test 7.4: Concurrent Operations
- [ ] Send message and like post simultaneously
- **Expected**: Both operations complete successfully

---

## Test Suite 8: Performance ✅

### Test 8.1: Load Time
- [ ] Measure signup flow completion time
- **Expected**: < 3 seconds

### Test 8.2: Chat Performance
- [ ] Load chat with 100+ messages
- **Expected**: Scroll smooth, messages load fast

### Test 8.3: Feed Performance
- [ ] Load feed with 50+ posts
- **Expected**: Smooth scrolling, pagination working

---

## Test Suite 9: Data Persistence ✅

### Test 9.1: Profile Completion
- [ ] Complete profile
- [ ] Close and reopen app
- **Expected**: Profile data persists

### Test 9.2: Message History
- [ ] Send 10 messages
- [ ] Close and reopen chat
- **Expected**: Message history preserved

### Test 9.3: Feed Data
- [ ] Create post
- [ ] Refresh feed
- **Expected**: Post still visible

---

## Test Results Summary

| Test Suite | Status | Notes |
|-----------|--------|-------|
| 1. Authentication | ⏳ Pending | |
| 2. Profile Setup | ⏳ Pending | |
| 3. Discover & Matching | ⏳ Pending | |
| 4. Connection Requests | ⏳ Pending | |
| 5. Messaging | ⏳ Pending | |
| 6. Posts & Feed | ⏳ Pending | |
| 7. Error Handling | ⏳ Pending | |
| 8. Performance | ⏳ Pending | |
| 9. Data Persistence | ⏳ Pending | |

---

## Known Limitations

1. **Image Upload**: Basic support - consider adding progress indicators
2. **Real-time Updates**: Currently polling-based - consider WebSockets for live features
3. **Offline Mode**: No offline queue system - all operations require internet
4. **Rate Limiting**: Not yet implemented - add for production
5. **Caching**: Minimal caching - optimize with proper cache strategy

---

## Recommended Next Steps

1. ✅ Run all tests in order
2. ✅ Document any bugs found
3. ✅ Performance testing under load
4. ✅ Security penetration testing
5. ✅ User acceptance testing
6. ✅ Deploy to staging environment

---

**Testing Status**: Ready for Execution
**Last Updated**: April 28, 2026
