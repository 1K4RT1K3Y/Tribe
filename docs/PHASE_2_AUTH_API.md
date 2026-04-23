# Phase 2: Authentication Module - API Documentation

## Overview
This document describes all authentication APIs for the Vibe backend.

## Base URL
```
http://localhost:5000/api/auth
```

## Endpoints

### 1. Register User
**POST** `/register`

Creates a new user account.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "confirmPassword": "password123"
}
```

**Success Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Error Response (400):**
```json
{
  "success": false,
  "message": "Email already registered"
}
```

**Validation Rules:**
- All fields required
- Email must be unique
- Email must be valid format
- Password must be at least 6 characters
- Password and confirmPassword must match

---

### 2. Login User
**POST** `/login`

Authenticates user and returns JWT token.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Invalid email or password"
}
```

---

### 3. Get Current User (Protected)
**GET** `/me`

Retrieves current authenticated user details.

**Headers:**
```
Authorization: Bearer {JWT_TOKEN}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "user": {
    "id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "profileComplete": false
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "No token provided"
}
```

---

## Authentication Flow

### Registration Flow
1. User enters: name, email, password, confirm password
2. Frontend validates locally
3. Frontend sends to `/register`
4. Backend validates and creates user
5. Backend returns JWT token
6. Frontend stores token in SharedPreferences
7. User redirected to profile setup

### Login Flow
1. User enters: email, password
2. Frontend validates locally
3. Frontend sends to `/login`
4. Backend finds user and compares password
5. Backend returns JWT token
6. Frontend stores token in SharedPreferences
7. User redirected to home feed

---

## Security Notes

- Passwords hashed with bcryptjs (salt rounds: 10)
- JWT tokens valid for 7 days
- Tokens stored in SharedPreferences (encrypted on mobile)
- All endpoints use HTTPS in production
- Rate limiting recommended on auth endpoints

---

## Flutter Integration

### AuthService Methods

```dart
// Register
await AuthService.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  confirmPassword: 'password123',
)

// Login
await AuthService.login(
  email: 'john@example.com',
  password: 'password123',
)

// Get Current User
await AuthService.getCurrentUser()

// Logout
await AuthService.logout()

// Check if logged in
bool isLoggedIn = await AuthService.isLoggedIn()
```

---

## Testing

### Test Registration
```
POST http://localhost:5000/api/auth/register
{
  "name": "Test User",
  "email": "test@example.com",
  "password": "Test@123",
  "confirmPassword": "Test@123"
}
```

### Test Login
```
POST http://localhost:5000/api/auth/login
{
  "email": "test@example.com",
  "password": "Test@123"
}
```

### Test Protected Route
```
GET http://localhost:5000/api/auth/me
Headers: Authorization: Bearer {token_from_login}
```

---

**Last Updated:** Phase 2 - Authentication Module
