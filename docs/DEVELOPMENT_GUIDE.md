# TiroConnect Development Guide

## Project Structure

```
TiroConnect/
├── flutter_app/           # Mobile application (Flutter)
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── src/
│   │   │   ├── app.dart               # Main app widget
│   │   │   ├── core/
│   │   │   │   ├── theme/
│   │   │   │   │   ├── app_colors.dart
│   │   │   │   │   └── app_theme.dart
│   │   │   │   ├── routes/
│   │   │   │   │   └── app_router.dart
│   │   │   │   ├── services/
│   │   │   │   │   ├── firebase_service.dart
│   │   │   │   │   └── api_service.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── custom_button.dart
│   │   │       │   └── custom_text_field.dart
│   │   │   └── features/
│   │   │       ├── auth/
│   │   │       │   ├── data/models/user_model.dart
│   │   │       │   ├── data/repositories/auth_repository.dart
│   │   │       │   └── presentation/
│   │   │       │       ├── pages/
│   │   │       │       │   ├── login_page.dart
│   │   │       │       │   ├── otp_verification_page.dart
│   │   │       │       │   └── register_page.dart
│   │   │       │       └── bloc/
│   │   │       │           ├── auth_bloc.dart
│   │   │       │           ├── auth_event.dart
│   │   │       │           └── auth_state.dart
│   │   │       ├── home/
│   │   │       │   └── presentation/pages/home_page.dart
│   │   │       ├── jobs/
│   │   │       │   ├── data/models/job_model.dart
│   │   │       │   ├── data/repositories/jobs_repository.dart
│   │   │       │   └── presentation/pages/job_posting_page.dart
│   │   │       ├── messaging/
│   │   │       │   └── presentation/pages/chat_page.dart
│   │   │       ├── payments/
│   │   │       │   └── presentation/pages/payment_page.dart
│   │   │       ├── profile/
│   │   │       │   └── presentation/pages/profile_page.dart
│   │   │       └── search/
│   │   │           └── presentation/pages/search_page.dart
│   └── pubspec.yaml
├── backend/               # NestJS API
│   ├── src/
│   │   ├── main.ts
│   │   ├── app.module.ts
│   │   ├── app.controller.ts
│   │   ├── auth/
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.service.ts
│   │   │   └── auth.controller.ts
│   │   ├── users/
│   │   │   ├── users.module.ts
│   │   │   ├── users.service.ts
│   │   │   └── entities/user.entity.ts
│   │   └── firebase/
│   │       └── firebase-admin.service.ts
│   └── package.json
├── admin_dashboard/       # React admin panel
│   ├── src/
│   │   ├── index.tsx
│   │   ├── App.tsx
│   │   ├── components/AdminLayout.tsx
│   │   └── pages/Dashboard.tsx
│   └── package.json
├── docs/
│   ├── api_documentation.md
│   ├── database_schema.sql
│   └── DEVELOPMENT_GUIDE.md
└── docker/
    ├── docker-compose.yml
    └── .github/workflows/ci-cd.yml
```

## Features Implemented

### Authentication
- Phone number login with Firebase OTP
- OTP verification
- User registration (Customer, Worker, Business)
- JWT token management

### Home Screen
- Search bar
- Service categories grid
- Featured workers carousel
- Emergency services banner
- Nearby workers section

### Job Management
- Job posting with all required fields
- Job search with filters
- Job application system
- Job status tracking

### Messaging
- Real-time chat interface
- Message bubbles
- Attachment support (placeholder)

### Profile
- User profile display
- Statistics (jobs, rating, earnings)
- Menu navigation

### Search
- Search with filters
- Category filtering
- Distance filtering
- Rating filtering
- Verified workers filter

### Admin Dashboard
- Responsive layout
- Navigation sidebar
- Dashboard with statistics
- Pages for users, workers, jobs, payments, etc.

## Next Steps

1. **Install Dependencies**
   - Flutter: `flutter pub get`
   - Backend: `npm install`
   - Admin: `npm install`

2. **Configure Environment**
   - Set up Firebase project
   - Configure environment variables
   - Set up PostgreSQL database

3. **Run the Application**
   - Backend: `npm run start:dev`
   - Flutter: `flutter run`
   - Admin: `npm start`

4. **Add Missing Features**
   - Google Maps integration
   - Push notifications
   - Payment gateway integration
   - AI matching algorithm
   - File upload functionality

## Testing

### Flutter Tests
```bash
flutter test
flutter test --coverage
```

### Backend Tests
```bash
npm run test
npm run test:e2e
```

## Deployment

The application is configured for Docker deployment:
```bash
cd docker
docker-compose up -d
```

This will start:
- PostgreSQL database
- Redis cache
- Backend API
- Admin dashboard
- Nginx reverse proxy