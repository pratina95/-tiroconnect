# TiroConnect API Documentation

## Overview

TiroConnect API is a RESTful API built with NestJS for Botswana's digital marketplace for blue-collar workers and skilled tradespeople.

**Base URL:** `https://api.tiroconnect.co.bw`

**Version:** 1.0.0

## Authentication

All API endpoints require authentication via JWT token, except for public endpoints.

### Authentication Flow

1. **Phone Authentication (Firebase OTP)**
   - Client sends phone number to Firebase
   - Firebase sends OTP to the phone
   - Client verifies OTP with Firebase
   - Client sends Firebase ID token to `/auth/login`
   - Server validates token and returns JWT

2. **JWT Token**
   - Include in Authorization header: `Bearer <token>`
   - Token expires in 7 days

## Endpoints

### Authentication

#### POST /auth/register/customer
Register a new customer account.

**Request Body:**
```json
{
  "fullName": "John Doe",
  "phoneNumber": "+26771234567",
  "email": "john@example.com",
  "nationalId": "123456789",
  "profilePicture": "https://...",
  "latitude": -24.6514,
  "longitude": 25.9083
}
```

**Response:**
```json
{
  "id": "uuid",
  "fullName": "John Doe",
  "phoneNumber": "+26771234567",
  "role": "customer",
  "isVerified": false,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

#### POST /auth/register/worker
Register a new worker account.

**Request Body:**
```json
{
  "fullName": "Jane Smith",
  "phoneNumber": "+26771234567",
  "email": "jane@example.com",
  "nationalId": "123456789",
  "profilePicture": "https://...",
  "latitude": -24.6514,
  "longitude": 25.9083,
  "skills": ["Plumbing", "Electrical"],
  "yearsOfExperience": 5,
  "certificates": ["https://..."],
  "portfolioImages": ["https://..."],
  "tradeLicense": "https://...",
  "hourlyRate": 500,
  "workingRadius": 50,
  "languagesSpoken": ["English", "Setswana"]
}
```

#### POST /auth/login
Login with Firebase ID token.

**Request Body:**
```json
{
  "idToken": "firebase-id-token"
}
```

**Response:**
```json
{
  "access_token": "jwt-token",
  "user": {
    "id": "uuid",
    "fullName": "John Doe",
    "phoneNumber": "+26771234567",
    "role": "customer"
  }
}
```

### Users

#### GET /users/{id}
Get user profile by ID.

**Response:**
```json
{
  "id": "uuid",
  "fullName": "John Doe",
  "phoneNumber": "+26771234567",
  "email": "john@example.com",
  "profilePicture": "https://...",
  "role": "worker",
  "isVerified": true,
  "isPremium": false,
  "workerProfile": {
    "skills": ["Plumbing", "Electrical"],
    "rating": 4.8,
    "completedJobs": 120,
    "hourlyRate": 500,
    "isAvailable": true
  }
}
```

#### PUT /users/{id}
Update user profile.

### Categories

#### GET /categories
Get all service categories.

**Response:**
```json
[
  {
    "id": "uuid",
    "name": "Plumbing",
    "description": "Water pipe installation and repair",
    "icon": "https://..."
  }
]
```

### Jobs

#### GET /jobs
Get jobs with optional filters.

**Query Parameters:**
- `lat` - Latitude for location-based search
- `lng` - Longitude for location-based search
- `radius` - Search radius in km
- `category` - Filter by category
- `status` - Filter by status (open, in_progress, completed, cancelled)

#### POST /jobs
Create a new job.

**Request Body:**
```json
{
  "title": "Fix leaking tap",
  "description": "Need to fix a leaking tap in the kitchen",
  "categoryId": "uuid",
  "budget": 300,
  "isNegotiable": true,
  "locationAddress": "Gaborone",
  "locationLat": -24.6514,
  "locationLng": 25.9083,
  "scheduledDate": "2024-01-15",
  "scheduledTime": "10:00",
  "urgency": "normal",
  "requiredSkills": ["Plumbing"]
}
```

#### POST /jobs/{id}/apply
Apply for a job.

**Request Body:**
```json
{
  "quotationAmount": 250,
  "message": "I can fix this today"
}
```

### Payments

#### POST /payments
Create a payment.

**Request Body:**
```json
{
  "jobId": "uuid",
  "amount": 500,
  "paymentMethod": "orange_money"
}
```

#### GET /payments/history
Get payment history for authenticated user.

### Messages

#### GET /messages/{conversationId}
Get messages in a conversation.

#### POST /messages
Send a message.

**Request Body:**
```json
{
  "conversationId": "uuid",
  "content": "Hello, I'm on my way",
  "messageType": "text"
}
```

### Reviews

#### POST /reviews
Create a review.

**Request Body:**
```json
{
  "revieweeId": "uuid",
  "jobId": "uuid",
  "rating": 5,
  "qualityRating": 5,
  "communicationRating": 5,
  "professionalismRating": 5,
  "punctualityRating": 5,
  "valueRating": 5,
  "cleanlinessRating": 5,
  "comment": "Great work!",
  "wouldRecommend": true
}
```

## Error Responses

All errors follow this format:

```json
{
  "statusCode": 400,
  "message": "Error message",
  "error": "Bad Request"
}
```

## Rate Limiting

API is rate-limited to 100 requests per minute per IP address.

## Security

- All endpoints use HTTPS
- JWT tokens for authentication
- Input validation on all endpoints
- SQL injection protection
- XSS protection
- CSRF protection