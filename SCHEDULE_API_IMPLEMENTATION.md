# Schedule API & Online Confirmation - Implementation ✅

**Date**: February 16, 2026

## Overview

Schedule ab API se fetch hota hai (local storage se nahi). Jab user online jata hai to doctor aur driver ka confirmation popup dikhta hai.

## API Details

### Endpoint
```
GET /api/get_schedule
```

### Headers
```
Authorization: Bearer {session_token}
```

### Request Body
```json
{
  "user_id": 11
}
```

### Response (200 OK)
```json
{
  "status": "success",
  "status_code": 200,
  "message": "Schedule fetched successfully",
  "data": [
    {
      "shift": "morning",
      "date": "16/02/2026",
      "ambulance_type_name": "M",
      "ambulance_id": 4,
      "ambulance_name": "Volkswagen/Golf 8/1-AUD-001",
      "driver_id": 8,
      "driver_name": "Eli Lambert",
      "emt_id": 22,
      "emt_name": "khusi",
      "nurse_id": false,
      "nurse_name": false,
      "doctor_id": 11,
      "doctor_name": "Doris Cole"
    }
  ]
}
```

## Implementation

### 1. API Endpoint Added ✅
**File**: `lib/core/constants/app_constants.dart`

```dart
static const String getScheduleEndpoint = '/api/get_schedule';
```

### 2. Schedule Provider Updated ✅
**File**: `lib/features/home/presentation/providers/schedule_provider.dart`

**Before** (Local Storage):
```dart
final scheduleJson = await storage.getSchedule();
final scheduleList = jsonDecode(scheduleJson);
```

**After** (API Call):
```dart
final userId = await storage.getUserId();

final response = await dio.get(
  AppConstants.getScheduleEndpoint,
  data: {'user_id': int.parse(userId)},
);

if (response.data['status'] == 'success') {
  final scheduleList = response.data['data'];
  return scheduleList.map((json) => ScheduleModel.fromJson(json)).toList();
}
```

### 3. Availability Provider Updated ✅
**File**: `lib/features/home/presentation/providers/availability_provider.dart`

**Changed**:
- `toggleAvailability()` now returns `Future<bool>`
- Returns `true` on success, `false` on failure
- Used for showing success/error messages

### 4. Home Screen Updated ✅
**File**: `lib/features/home/presentation/screens/home_screen.dart`

**New Features**:
1. Online confirmation dialog
2. Shows doctor and driver info
3. Shows ambulance details
4. Confirm button to go online
5. Success/error feedback

## How It Works

### Schedule Fetch Flow
```
1. Home screen loads
   ↓
2. scheduleProvider called
   ↓
3. Get user_id from storage
   ↓
4. API call: GET /api/get_schedule
   Body: {"user_id": 11}
   ↓
5. Parse response to ScheduleModel list
   ↓
6. todayScheduleProvider filters today's schedule
   ↓
7. Display in UI
```

### Online Toggle Flow

#### Going Online (with confirmation):
```
1. User toggles switch ON
   ↓
2. Check if today's schedule exists
   ↓
3. Show confirmation dialog:
   ┌─────────────────────────┐
   │ Go Online?              │
   │                         │
   │ Confirm your team:      │
   │ 🚗 Driver: Eli Lambert  │
   │ 🏥 Doctor: Doris Cole   │
   │                         │
   │ Ambulance: Volkswagen   │
   │ 1-AUD-001               │
   │                         │
   │ [Cancel]  [Confirm]     │
   └─────────────────────────┘
   ↓
4. User clicks Confirm
   ↓
5. API call: POST /api/check_in_out
   Body: {user_id: 11, check_in: 1}
   ↓
6. Success message: "You are now online!"
   ↓
7. Status updated to Online
```

#### Going Offline (no confirmation):
```
1. User toggles switch OFF
   ↓
2. API call: POST /api/check_in_out
   Body: {user_id: 11, check_in: 0}
   ↓
3. Status updated to Offline
```

#### No Schedule for Today:
```
1. User toggles switch ON
   ↓
2. Check today's schedule
   ↓
3. No schedule found
   ↓
4. Show error message:
   "No schedule found for today. Please contact admin."
   ↓
5. Switch remains OFF
```

## UI Components

### Confirmation Dialog
```
┌─────────────────────────────────┐
│ Go Online?                      │
│                                 │
│ Confirm your team for today:   │
│                                 │
│ 🚗 Driver: Eli Lambert          │
│ 🏥 Doctor: Doris Cole           │
│                                 │
│ Ambulance: Volkswagen 1-AUD-001 │
│                                 │
│         [Cancel]  [Confirm]     │
└─────────────────────────────────┘
```

### Success Message
```
┌─────────────────────────────────┐
│ ✓ You are now online!           │
└─────────────────────────────────┘
```

### Error Message (No Schedule)
```
┌─────────────────────────────────┐
│ ⚠ No schedule found for today.  │
│   Please contact admin.         │
└─────────────────────────────────┘
```

### Error Message (API Failed)
```
┌─────────────────────────────────┐
│ ✗ Failed to go online           │
└─────────────────────────────────┘
```

## Code Details

### API Call
```dart
final response = await dio.get(
  AppConstants.getScheduleEndpoint,
  data: {'user_id': int.parse(userId)},
);
```

### Confirmation Dialog
```dart
void _showOnlineConfirmation(
  BuildContext context,
  WidgetRef ref,
  schedule,
) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Go Online?'),
      content: Column(
        children: [
          Text('Confirm your team for today:'),
          _buildTeamInfo(context, Icons.drive_eta, 'Driver', schedule.driverNameSafe),
          _buildTeamInfo(context, Icons.medical_services, 'Doctor', schedule.doctorNameSafe),
          Text('Ambulance: ${schedule.ambulanceVehicle} ${schedule.ambulancePlate}'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            final success = await ref.read(availabilityProvider.notifier).toggleAvailability();
            // Show success/error message
          },
          child: Text('Confirm'),
        ),
      ],
    ),
  );
}
```

### Switch Handler
```dart
Switch(
  value: availabilityState.isOnline,
  onChanged: (value) async {
    if (!availabilityState.isOnline) {
      // Going online - show confirmation
      final todaySchedule = await ref.read(todayScheduleProvider.future);
      
      if (todaySchedule != null) {
        _showOnlineConfirmation(context, ref, todaySchedule);
      } else {
        // No schedule - show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No schedule found for today')),
        );
      }
    } else {
      // Going offline - no confirmation
      ref.read(availabilityProvider.notifier).toggleAvailability();
    }
  },
)
```

## Testing

### 1. Test Schedule API
```
1. Login with user who has schedule
2. Home screen loads
3. Check logs: [SCHEDULE] Fetched X schedules
4. See today's schedule card (if today has schedule)
5. See upcoming shifts list
```

### 2. Test Online Confirmation
```
1. Make sure you have schedule for today
2. Toggle switch ON
3. See confirmation dialog with:
   - Driver name
   - Doctor name
   - Ambulance details
4. Click "Confirm"
5. See success message: "You are now online!"
6. Status shows "Online" (green)
```

### 3. Test No Schedule
```
1. Login with user who has no schedule for today
2. Toggle switch ON
3. See error message: "No schedule found for today"
4. Switch remains OFF
```

### 4. Test Offline (No Confirmation)
```
1. When online, toggle switch OFF
2. No confirmation dialog
3. Directly goes offline
4. Status shows "Offline" (grey)
```

## Debug Logs

### Schedule API Success
```
[SCHEDULE] Response: {status: success, data: [...]}
[SCHEDULE] Fetched 3 schedules
```

### Schedule API Error
```
[SCHEDULE ERROR] DioException: Connection timeout
[SCHEDULE ERROR] Response: {status: failure, message: ...}
```

### Online Toggle Success
```
[AVAILABILITY] Status updated - User ID: 11, Online: true
```

### Online Toggle Error
```
[AVAILABILITY ERROR] Failed to update availability
```

## Edge Cases Handled

### ✅ No Schedule for Today
- Shows error message
- Switch remains OFF
- User informed to contact admin

### ✅ API Failure
- Shows error message
- Switch reverts to previous state
- User can retry

### ✅ No User ID
- Shows error: "User ID not found. Please login again."
- Prevents API call

### ✅ Going Offline
- No confirmation needed
- Direct API call
- Smooth transition

## Files Modified

1. ✅ `lib/core/constants/app_constants.dart` - Added get_schedule endpoint
2. ✅ `lib/features/home/presentation/providers/schedule_provider.dart` - API integration
3. ✅ `lib/features/home/presentation/providers/availability_provider.dart` - Return bool
4. ✅ `lib/features/home/presentation/screens/home_screen.dart` - Confirmation dialog

## Summary

**Kya Hua**:
- ✅ Schedule ab API se fetch hota hai
- ✅ Local storage use nahi hota
- ✅ Online jate waqt confirmation dialog
- ✅ Doctor aur driver ka naam dikhta hai
- ✅ Ambulance details dikhti hain
- ✅ Confirm button se online hota hai
- ✅ Success/error messages
- ✅ No schedule = error message
- ✅ Offline = no confirmation

**API Call**:
```
GET /api/get_schedule
Authorization: Bearer {token}
Body: {"user_id": 11}
```

**Confirmation Dialog**:
- Driver name
- Doctor name
- Ambulance details
- Confirm/Cancel buttons

**Test Karo**:
1. Login karo
2. Home screen pe schedule dekhoge (API se)
3. Online toggle karo
4. Confirmation dialog dekhoge
5. Confirm karo
6. Online ho jaoge!

---

**Status**: ✅ Complete - Schedule API & Confirmation Ready!

**Test Credentials**: User with schedule data
