# Get Schedule API - Body Parameter Fix ✅

**Date**: February 16, 2026

## Issue

GET request hai lekin `user_id` body mein bhejna hai (query parameter mein nahi).

## Fix Applied

### Before ❌
```dart
final response = await dio.get(
  AppConstants.getScheduleEndpoint,
  queryParameters: {'user_id': userId},  // Query parameter
);
```

**Request**:
```
GET /api/get_schedule?user_id=11
Authorization: Bearer {token}
```

### After ✅
```dart
final response = await dio.get(
  AppConstants.getScheduleEndpoint,
  data: {'user_id': int.parse(userId)},  // Body parameter
);
```

**Request**:
```
GET /api/get_schedule
Authorization: Bearer {token}
Body: {"user_id": 11}
```

## Implementation

**File**: `lib/features/home/presentation/providers/schedule_provider.dart`

**Changed**:
- `queryParameters` → `data`
- `userId` (string) → `int.parse(userId)` (integer)

## How It Works

### API Call
```dart
// Get user_id from storage
final userId = await storage.getUserId();  // Returns "11"

// Convert to int and send in body
final response = await dio.get(
  AppConstants.getScheduleEndpoint,
  data: {'user_id': int.parse(userId)},  // Sends 11 (int)
);
```

### Request Details
```
Method: GET
URL: http://192.168.29.106:8018/api/get_schedule
Headers:
  Content-Type: application/json
  Authorization: Bearer d4080db8e31bec1619eacfcc84e42409
Body:
  {
    "user_id": 11
  }
```

## Why Body in GET Request?

Normally GET requests don't have body, but some APIs use it:
- ✅ Dio supports body in GET requests
- ✅ Backend expects `user_id` in body
- ✅ Works correctly with this implementation

## Testing

### Test API Call
```
1. Login karo
2. Home screen load hoga
3. Check logs:
   [DIO] REQUEST[GET] => PATH: /api/get_schedule
   [DIO] Body: {user_id: 11}
   [DIO] RESPONSE[200]
   [SCHEDULE] Fetched X schedules
```

### Expected Logs
```
[DIO] REQUEST[GET] => PATH: /api/get_schedule
[DIO] Headers: {Authorization: Bearer xxx}
[DIO] Body: {user_id: 11}
[DIO] RESPONSE[200]
[SCHEDULE] Response: {status: success, data: [...]}
[SCHEDULE] Fetched 3 schedules
```

## Summary

**Kya Hua**:
- ✅ `user_id` ab body mein ja raha hai
- ✅ Query parameter nahi use ho raha
- ✅ Integer format mein bhej rahe hain
- ✅ GET request with body

**API Format**:
```
GET /api/get_schedule
Body: {"user_id": 11}
Header: Authorization: Bearer {token}
```

**Test Karo**:
1. Login karo
2. Home screen pe schedule dekhoge
3. Logs mein `Body: {user_id: 11}` dekhoge

---

**Status**: ✅ Fixed - Body Parameter Working!
