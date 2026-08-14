# How to Run TiroConnect

## Prerequisites
- Flutter SDK 3.4+
- Android Studio / VS Code with Flutter extension
- Android/iOS emulator or device

## Quick Start

### 1. Install Flutter Dependencies
```powershell
cd TiroConnect\flutter_app
flutter pub get
```

### 2. Run the Flutter App
```powershell
flutter run
```

### 3. For Web (if supported)
```powershell
flutter run -d chrome
```

## Project Structure
```
TiroConnect/
├── flutter_app/          # Mobile app - run this
│   ├── lib/
│   │   ├── main.dart     # Entry point
│   │   └── src/
│   │       ├── app.dart
│   │       ├── core/
│   │       └── features/
│   └── pubspec.yaml
├── backend/              # API (Node.js/NestJS)
├── admin_dashboard/      # Admin panel (React)
├── docs/                 # Documentation
└── docker/               # Docker config
```

## Current Features
- Login with phone number
- OTP verification
- User registration (Customer/Worker/Business)
- Home screen with categories
- Job posting
- Search with filters
- Messaging
- Profile page

## Notes
- The app uses Firebase for authentication
- For testing, you can use any Botswana phone number format (+267 or 267)
- Payment features are suspended as requested
- Backend and admin dashboard require additional setup