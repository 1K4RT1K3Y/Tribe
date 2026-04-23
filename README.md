# 🎯 Vibe - Social Media & Interest-based Matching App

## Project Overview
Vibe is a full-stack social media application with intelligent interest-based matching. Users can connect based on shared interests, post updates, chat, and discover new matches.

## 📋 Technology Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Node.js + Express.js
- **Database**: MongoDB
- **Authentication**: JWT (JSON Web Tokens)
- **Password Hashing**: bcryptjs

## 🚀 Project Structure
```
Tribe/
├── backend/          # Node.js + Express Backend
│   ├── models/       # MongoDB Schemas
│   ├── routes/       # API Routes
│   ├── controllers/  # Business Logic
│   ├── middleware/   # Auth & Validation
│   ├── config/       # Database & Config
│   ├── utils/        # Utility Functions
│   ├── server.js     # Main Server Entry
│   └── package.json
│
├── frontend/         # Flutter App
│   ├── lib/
│   │   ├── screens/      # UI Screens
│   │   ├── services/     # API Services
│   │   ├── providers/    # State Management
│   │   ├── models/       # Data Models
│   │   ├── widgets/      # Custom Widgets
│   │   └── main.dart
│   └── pubspec.yaml
│
└── docs/            # Project Documentation
```

## 📝 Development Phases (Strict Order)

### Phase 1: ✅ Project Setup
- [x] Created backend (Node.js + Express)
- [x] Created frontend (Flutter)
- [x] Installed all dependencies
- [x] Set up folder structure
- [x] Initialized git repo

### Phase 2: 🔐 Authentication Module (NEXT)
- [ ] Create User Schema
- [ ] Build Register API
- [ ] Build Login API
- [ ] Implement JWT tokens
- [ ] Password hashing with bcrypt
- [ ] Build Flutter Login/Signup UI

### Phase 3: 👤 Profile Module
- [ ] Add profile fields (bio, interests, hobbies)
- [ ] Create Profile Schema
- [ ] Build Profile APIs
- [ ] Build Flutter Profile UI

### Phase 4: 📝 Posts Module
- [ ] Create Post Schema
- [ ] Build Post APIs
- [ ] Build Feed Screen
- [ ] Add Comment functionality

### Phase 5: 💞 Vibe Matching
- [ ] Store user interests
- [ ] Implement matching algorithm
- [ ] Build Suggestions UI

### Phase 6: 💬 Messaging
- [ ] Create Message Schema
- [ ] Build Messaging APIs
- [ ] Build Chat UI

### Phase 7: 🔔 Notifications
- [ ] Create Notification Schema
- [ ] Build Notification System

### Phase 8: 🧪 Testing & Verification
- [ ] Test all APIs
- [ ] Test Flutter App
- [ ] Fix bugs

### Phase 9: 📚 Documentation
- [ ] API Documentation
- [ ] Setup Guide
- [ ] Deployment Guide

## 🛠️ Quick Start

### Backend Setup
```bash
cd backend
npm install
npm run dev
# Backend runs on http://localhost:5000
```

### Frontend Setup
```bash
cd frontend
flutter pub get
flutter run
```

## ⚙️ Environment Variables
Create `.env` file in backend folder with:
```
PORT=5000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/vibedatabase
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRE=7d
NODE_ENV=development
```

## 🎯 MVP Features
- ✅ User Registration & Login
- ✅ JWT Authentication
- ✅ Profile Management
- ✅ Post Creation & Feed
- ✅ Comments on Posts
- ✅ Vibe Matching (Interest-based)
- ✅ One-to-One Messaging
- ✅ Basic Notifications

## 🔮 Future Enhancements
- AI-based matching
- Voice/Video calling
- Location-based meetups
- Community groups
- Advanced recommendations
- Push notifications

## 📞 API Endpoints (To be implemented)

### Auth APIs
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

### User APIs
- `GET /api/users/:userId` - Get user profile
- `PUT /api/users/:userId` - Update profile
- `GET /api/users/suggestions/matches` - Get suggested matches

### Post APIs
- `POST /api/posts` - Create post
- `GET /api/posts` - Get feed
- `POST /api/posts/:postId/comment` - Add comment

### Message APIs
- `POST /api/messages` - Send message
- `GET /api/messages/:userId` - Get chat history

### Notification APIs
- `GET /api/notifications` - Get all notifications
- `PUT /api/notifications/:notificationId/read` - Mark as read

## 📊 Database Schema (Preview)

### Users Collection
```
{
  _id: ObjectId
  name: String
  email: String (unique)
  password: String (hashed)
  bio: String
  interests: [String]
  hobbies: [String]
  createdAt: Date
  updatedAt: Date
}
```

## 🐛 Known Issues & Notes
- None yet - Fresh start!

## 📅 Started: April 23, 2026
---

**Last Updated**: Phase 1 Complete ✅
