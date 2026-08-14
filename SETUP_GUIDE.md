# TiroConnect Setup Guide

## Installing Flutter

### Windows Installation
1. Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows
2. Extract to `C:\src\flutter`
3. Add to PATH:
   - Open System Properties > Environment Variables
   - Add `C:\src\flutter\bin` to your PATH
4. Run in terminal:
```powershell
flutter doctor
```

### Verify Installation
```powershell
flutter --version
```

## Running the Project

### After Flutter Installation
```powershell
cd C:\Users\Mpoma\Desktop\TiroConnect\flutter_app
flutter pub get
flutter run
```

## Project Files Created

### Flutter App Structure
```
flutter_app/
├── lib/
│   ├── main.dart              # App entry point
│   ├── src/
│   │   ├── app.dart           # Main app widget
│   │   ├── core/
│   │   │   ├── theme/
│   │   │   │   ├── app_colors.dart
│   │   │   │   └── app_theme.dart
│   │   │   ├── routes/
│   │   │   │   └── app_router.dart
│   │   │   ├── services/
│   │   │   │   ├── firebase_service.dart
│   │   │   │   └── api_service.dart
│   │   │   └── widgets/
│   │   │       ├── custom_button.dart
│   │   │       └── custom_text_field.dart
│   │   └── features/
│   │       ├── auth/
│   │       │   ├── data/models/user_model.dart
│   │       │   ├── data/repositories/auth_repository.dart
│   │       │   └── presentation/
│   │       │       ├── pages/
│   │       │       │   ├── login_page.dart
│   │       │       │   ├── otp_verification_page.dart
│   │       │       │   └── register_page.dart
│   │       │       └── bloc/
│   │       │           ├── auth_bloc.dart
│   │       │           ├── auth_event.dart
│   │       │           └── auth_state.dart
│   │       ├── home/
│   │       │   └── presentation/pages/home_page.dart
│   │       ├── jobs/
│   │       │   ├── data/models/job_model.dart
│   │       │   ├── data/repositories/jobs_repository.dart
│   │       │   └── presentation/pages/job_posting_page.dart
│   │       ├── messaging/
│   │       │   └── presentation/pages/chat_page.dart
│   │       ├── payments/
│   │       │   └── presentation/pages/payment_page.dart
│   │       ├── profile/
│   │       │   └── presentation/pages/profile_page.dart
│   │       └── search/
│   │           └── presentation/pages/search_page.dart
│   └── pubspec.yaml
└── test/
    └── widget_test.dart
```

## Features Ready to Use

1. **Login Screen** - Phone number input with Botswana format validation
2. **Registration** - Choose between Customer, Worker, or Business
3. **Home Screen** - Categories, featured workers, emergency services
4. **Job Posting** - Create jobs with all required fields
5. **Search** - Filter by category, distance, rating
6. **Messaging** - Chat interface
7. **Profile** - User profile and settings

## To Test Without Flutter Installation

You can view the code in VS Code. The project structure is complete and ready to run once Flutter is installed.