# TiroConnect

**Connecting Skills. Creating Opportunities.**

Botswana's digital marketplace for blue-collar workers, skilled tradespeople, freelancers, and odd jobs.

## Overview

TiroConnect is a comprehensive platform that connects customers who need work done with verified workers who can complete jobs professionally. The application supports multiple user types including customers, workers, businesses, and administrators.

## Technology Stack

### Frontend
- **Flutter** (latest stable) - Cross-platform mobile app
- **Dart** - Programming language

### Backend
- **NestJS** - Node.js framework
- **PostgreSQL** - Database
- **Firebase** - Authentication, Storage, Cloud Messaging
- **JWT** - Token-based authentication

### Infrastructure
- **Docker** - Containerization
- **GitHub Actions** - CI/CD
- **Nginx** - Reverse proxy

## Project Structure

```
TiroConnect/
├── flutter_app/           # Mobile application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── src/
│   │   │   ├── app.dart
│   │   │   ├── core/
│   │   │   │   ├── theme/
│   │   │   │   ├── routes/
│   │   │   │   ├── services/
│   │   │   │   └── widgets/
│   │   │   └── features/
│   │   │       ├── auth/
│   │   │       ├── home/
│   │   │       ├── jobs/
│   │   │       ├── messaging/
│   │   │       ├── payments/
│   │   │       └── profile/
│   └── pubspec.yaml
├── backend/               # NestJS API
│   ├── src/
│   │   ├── main.ts
│   │   ├── app.module.ts
│   │   ├── auth/
│   │   ├── users/
│   │   ├── jobs/
│   │   ├── payments/
│   │   └── ...
│   └── package.json
├── admin_dashboard/       # React admin panel
├── docs/                  # Documentation
│   ├── api_documentation.md
│   └── database_schema.sql
└── docker/                # Docker configuration
    ├── docker-compose.yml
    └── .github/workflows/
```

## Features

### User Types
- **Customers** - Post jobs, hire workers, make payments
- **Workers** - Offer services, apply for jobs, receive payments
- **Businesses** - Hire multiple workers, manage departments
- **Administrators** - Manage platform, verify users, handle disputes

### Core Features
- Phone authentication with OTP (Firebase)
- Real-time messaging with text, images, videos
- Job posting with images, videos, and location
- AI-powered job matching
- Multiple payment methods (Orange Money, MyZaka, Cards, Cash)
- GPS navigation and tracking
- Rating and review system
- Push notifications

## Getting Started

### Prerequisites
- Flutter SDK 3.4+
- Node.js 18+
- PostgreSQL 15+
- Docker (optional)

### Installation

#### Backend
```bash
cd backend
npm install
npm run start:dev
```

#### Flutter App
```bash
cd flutter_app
flutter pub get
flutter run
```

#### Admin Dashboard
```bash
cd admin_dashboard
npm install
npm start
```

### Docker
```bash
cd docker
docker-compose up -d
```

## API Documentation

See [docs/api_documentation.md](docs/api_documentation.md) for API endpoints.

## Database Schema

See [docs/database_schema.sql](docs/database_schema.sql) for database structure.

## Environment Variables

### Backend (.env)
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=tiroconnect
JWT_SECRET=your-secret-key
FIREBASE_PROJECT_ID=your-project-id
```

## Testing

### Backend
```bash
npm run test
npm run test:e2e
```

### Flutter
```bash
flutter test
```

## Deployment

The application is designed for production deployment with:
- Docker containerization
- CI/CD pipeline
- SSL/TLS support
- Rate limiting
- Security headers

## License

MIT License

## Contact

For support, email support@tiroconnect.co.bw