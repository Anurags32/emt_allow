# EMT App - Emergency Medical Services

A professional Flutter mobile application for ambulance staff (EMT, Nurse, Doctor) to manage emergency missions and patient care.

## Overview

EMT App is designed exclusively for registered medical personnel to handle emergency missions, patient data, and medical documentation. The app follows clean architecture principles with feature-based modular structure.

## Key Features

- **Authentication**: Login-only flow for registered personnel (NO signup)
- **Availability Management**: Online/Offline duty status toggle
- **Mission Management**: View and manage active emergency missions
- **Ambulance Assignment**: View assigned ambulance details
- **Patient Information**: Access patient details, medical history, and questionnaires
- **Medical Notes**: Add text notes with photo/document attachments
- **Mission Lock**: Read-only mode after mission completion
- **Patient Handover**: Complete handover process to clinic
- **Profile Management**: View user info and logout

## Tech Stack

- **Flutter**: Latest stable version
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Networking**: Dio
- **Storage**: Flutter Secure Storage
- **Serialization**: json_serializable
- **Image Picker**: For medical photos
- **File Picker**: For document attachments

## Architecture

The app follows **Clean Architecture** with feature-based modules:

```
lib/
├── core/                    # Core utilities
│   ├── constants/          # App constants
│   ├── network/            # Dio client
│   ├── router/             # GoRouter configuration
│   ├── storage/            # Secure storage service
│   └── theme/              # App theme
├── domain/                  # Domain models
│   └── models/             # Data models
├── data/                    # Data layer
│   └── repositories/       # Repository implementations
└── features/               # Feature modules
    ├── auth/               # Authentication
    ├── home/               # Home dashboard
    ├── ambulance/          # Ambulance assignment
    ├── mission/            # Mission management
    ├── patient/            # Patient details
    ├── medical_notes/      # Medical notes
    ├── handover/           # Patient handover
    └── profile/            # User profile
```

## User Roles

- **EMT** (Emergency Medical Technician)
- **Nurse**
- **Doctor**

Role is determined by backend response after login.

## App Flow

1. **Splash Screen** → Check JWT token → Navigate to Home or Login
2. **Login Screen** → Employee ID/Email + Password → Home
3. **Home Screen** → Availability toggle + Active mission card
4. **Mission Details** → View mission info, timeline, clinic details
5. **Patient Details** → View patient info, medical history
6. **Medical Notes** → Add/view notes with attachments
7. **Patient Handover** → Complete handover to clinic
8. **Mission Completed** → Success screen → Back to Home

## Mission Lock State

Once a mission is marked as completed or locked:
- Medical notes become **READ ONLY**
- No new notes can be added
- UI displays lock message

## Backend Integration

Currently using **mock repositories** with hardcoded data.

### TODO: Odoo API Integration

All repository files are marked with `TODO` comments for backend integration:

- `lib/data/repositories/auth_repository.dart` - Login API
- `lib/data/repositories/ambulance_repository.dart` - Ambulance data
- `lib/data/repositories/mission_repository.dart` - Mission data
- `lib/data/repositories/patient_repository.dart` - Patient data
- `lib/data/repositories/medical_notes_repository.dart` - Notes & attachments

Update `lib/core/constants/app_constants.dart` with actual API endpoints.

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Generate Code (if needed)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Mock Login Credentials

For testing, any email/password combination will work with mock data.

Example:
- Email: `emt@example.com`
- Password: `password`

## Important Notes

- **NO Google Maps**: Location handling is done by backend/driver app
- **NO Map UI**: No polylines, navigation, or location display
- **Mission-focused**: App is purely for medical data and mission management
- **Offline-safe**: Form handling queues data when offline (to be implemented)
- **Secure**: JWT tokens stored in secure storage

## Project Structure Highlights

### State Management (Riverpod)

- `StateNotifierProvider` for mutable state
- `FutureProvider` for async data loading
- `Provider` for dependency injection

### Navigation (GoRouter)

All routes defined in `lib/core/router/app_router.dart`

### Models

All models use `json_serializable` for JSON parsing with generated `.g.dart` files.

## UI/UX

- **Material 3** design
- **Light & Dark mode** ready
- Professional medical-grade UI
- Clean, minimal, readable layouts
- Proper loading, empty, and error states

## Future Enhancements

- Real-time mission updates
- Push notifications
- Offline data sync
- Voice notes
- Vital signs tracking
- E-signature for handover

## License

Private project - All rights reserved

## Contact

For support or questions, contact the development team.
