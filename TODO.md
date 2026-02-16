# EMT App - TODO List

## Backend Integration (HIGH PRIORITY)

### 1. Update API Configuration
- [ ] Update `lib/core/constants/app_constants.dart` with actual Odoo base URL
- [ ] Configure API endpoints for all services
- [ ] Set up proper authentication headers

### 2. Auth Repository
File: `lib/data/repositories/auth_repository.dart`
- [ ] Implement actual login API call
- [ ] Handle API errors and validation
- [ ] Parse JWT token from response
- [ ] Implement token refresh logic
- [ ] Add proper error messages

### 3. Ambulance Repository
File: `lib/data/repositories/ambulance_repository.dart`
- [ ] Implement getAssignedAmbulance() API call
- [ ] Implement getAvailableAmbulances() API call
- [ ] Handle empty/null responses

### 4. Mission Repository
File: `lib/data/repositories/mission_repository.dart`
- [ ] Implement getActiveMission() API call
- [ ] Implement getMissionById() API call
- [ ] Implement updateMissionStatus() API call
- [ ] Implement completeMission() API call
- [ ] Parse mission timeline from API

### 5. Patient Repository
File: `lib/data/repositories/patient_repository.dart`
- [ ] Implement getPatientByMissionId() API call
- [ ] Parse questionnaire data
- [ ] Handle medical history data

### 6. Medical Notes Repository
File: `lib/data/repositories/medical_notes_repository.dart`
- [ ] Implement getNotesByMissionId() API call
- [ ] Implement createNote() API call
- [ ] Implement uploadAttachment() API call
- [ ] Handle file upload with multipart/form-data
- [ ] Add progress tracking for uploads

### 7. Availability API
File: `lib/features/home/presentation/providers/availability_provider.dart`
- [ ] Implement API call to update duty status
- [ ] Sync status with backend

## Features to Implement

### Offline Support
- [ ] Implement local database (SQLite/Hive)
- [ ] Queue medical notes when offline
- [ ] Sync queued data when online
- [ ] Show offline indicator in UI
- [ ] Cache mission and patient data

### Real-time Updates
- [ ] Implement WebSocket connection
- [ ] Listen for mission assignments
- [ ] Update mission status in real-time
- [ ] Show notifications for updates

### Push Notifications
- [ ] Set up Firebase Cloud Messaging
- [ ] Handle mission assignment notifications
- [ ] Handle mission status updates
- [ ] Add notification permissions

### Enhanced Medical Notes
- [ ] Add voice recording capability
- [ ] Implement image compression before upload
- [ ] Add image preview before upload
- [ ] Support multiple file uploads
- [ ] Add note editing capability (if mission not locked)

### Mission Status Updates
- [ ] Add buttons to update mission status
- [ ] Implement status change confirmation
- [ ] Add status change notes
- [ ] Track status change history

### Vital Signs Tracking
- [ ] Create vital signs model
- [ ] Add vital signs input screen
- [ ] Display vital signs history
- [ ] Add vital signs to medical notes

### Patient Search
- [ ] Implement patient search functionality
- [ ] Add patient history view
- [ ] Show previous missions for patient

## UI/UX Improvements

### Loading States
- [ ] Add skeleton loaders for cards
- [ ] Improve loading indicators
- [ ] Add shimmer effects

### Error Handling
- [ ] Create error dialog component
- [ ] Add retry mechanisms
- [ ] Show user-friendly error messages
- [ ] Add error logging

### Animations
- [ ] Add page transitions
- [ ] Add card animations
- [ ] Add success animations
- [ ] Add loading animations

### Accessibility
- [ ] Add semantic labels
- [ ] Test with screen readers
- [ ] Improve color contrast
- [ ] Add font size options

## Testing

### Unit Tests
- [ ] Test all repository methods
- [ ] Test all providers
- [ ] Test model serialization
- [ ] Test utility functions

### Widget Tests
- [ ] Test all screens
- [ ] Test form validation
- [ ] Test button interactions
- [ ] Test navigation

### Integration Tests
- [ ] Test complete login flow
- [ ] Test mission workflow
- [ ] Test medical notes flow
- [ ] Test handover process

## Performance Optimization

- [ ] Implement image caching
- [ ] Add pagination for notes list
- [ ] Optimize list rendering
- [ ] Reduce unnecessary rebuilds
- [ ] Profile app performance

## Security

- [ ] Implement certificate pinning
- [ ] Add biometric authentication
- [ ] Implement session timeout
- [ ] Add data encryption at rest
- [ ] Implement secure file storage

## Documentation

- [ ] Add inline code documentation
- [ ] Create API documentation
- [ ] Add user manual
- [ ] Create deployment guide
- [ ] Add troubleshooting guide

## DevOps

- [ ] Set up CI/CD pipeline
- [ ] Configure automated testing
- [ ] Set up code coverage
- [ ] Configure app signing
- [ ] Set up crash reporting (Firebase Crashlytics)
- [ ] Add analytics (Firebase Analytics)

## App Store Preparation

- [ ] Create app icons
- [ ] Create splash screens
- [ ] Prepare screenshots
- [ ] Write app description
- [ ] Create privacy policy
- [ ] Create terms of service

## Code Quality

- [ ] Run flutter analyze
- [ ] Fix all linting warnings
- [ ] Add missing documentation
- [ ] Refactor duplicate code
- [ ] Optimize imports

## Platform-Specific

### Android
- [ ] Configure app permissions
- [ ] Set up ProGuard rules
- [ ] Configure app signing
- [ ] Test on multiple devices

### iOS
- [ ] Configure app permissions
- [ ] Set up code signing
- [ ] Configure push notifications
- [ ] Test on multiple devices

## Localization (Future)

- [ ] Set up i18n
- [ ] Add English translations
- [ ] Add other language support
- [ ] Test RTL languages

## Notes

- All TODO comments in code files should be addressed
- Mock data should be replaced with actual API calls
- Error handling should be comprehensive
- User feedback should be clear and helpful
- Performance should be monitored and optimized
