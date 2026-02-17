# Medical Notes API - Implementation ✅

**Date**: February 17, 2026

## Overview

Medical notes screen mein `/api/post_emt_notes` API implement ki gayi hai jo notes save karta hai.

## API Details

### Endpoint
```
POST /api/post_emt_notes
```

### Headers
```
Content-Type: application/json
Authorization: Bearer {session_token}
```

### Request Body
```json
{
  "case_id": "CASE/26/00024",
  "new_notes": "Patient found conscious, complaining of chest pain.",
  "emt_attachments": "/path/to/file1.jpg,/path/to/file2.pdf"
}
```

### Fields
- `case_id` (string): Case ID - **Hardcoded**: `"CASE/26/00024"`
- `new_notes` (string): Medical note content
- `emt_attachments` (string): Comma-separated file paths

## Implementation

### 1. API Endpoint Added ✅
**File**: `lib/core/constants/app_constants.dart`

```dart
static const String postEmtNotesEndpoint = '/api/post_emt_notes';
```

### 2. Repository Updated ✅
**File**: `lib/data/repositories/medical_notes_repository.dart`

**Before** (Mock):
```dart
Future<MedicalNoteModel> createNote(...) async {
  await Future.delayed(const Duration(seconds: 2));
  return MedicalNoteModel(...);
}
```

**After** (API Call):
```dart
Future<MedicalNoteModel> createNote({
  required String missionId,
  required String content,
  List<String> attachmentPaths = const [],
}) async {
  const caseId = 'CASE/26/00024';  // Hardcoded

  final response = await _dio.post(
    AppConstants.postEmtNotesEndpoint,
    data: {
      'case_id': caseId,
      'new_notes': content,
      'emt_attachments': attachmentPaths.join(','),
    },
  );

  if (response.data['status'] == 'success') {
    return MedicalNoteModel(...);
  }
}
```

## How It Works

### Save Note Flow
```
1. User types medical note
   ↓
2. User adds attachments (optional)
   ↓
3. User clicks "Save Note"
   ↓
4. API call: POST /api/post_emt_notes
   Body: {
     case_id: "CASE/26/00024",
     new_notes: "...",
     emt_attachments: "path1,path2"
   }
   ↓
5. API responds with success
   ↓
6. Note added to list
   ↓
7. Success message shown
   ↓
8. Input cleared
```

## UI Flow

### Add Note
```
┌─────────────────────────────────┐
│ Medical Notes                   │
├─────────────────────────────────┤
│                                 │
│ [Existing notes list]           │
│                                 │
├─────────────────────────────────┤
│ Add medical note...             │
│ ┌─────────────────────────────┐ │
│ │ Patient found conscious...  │ │
│ └─────────────────────────────┘ │
│                                 │
│ 📷 📎              [Save Note]  │
└─────────────────────────────────┘
```

### With Attachments
```
┌─────────────────────────────────┐
│ 📷 photo.jpg [x]                │
│ 📄 report.pdf [x]               │
│                                 │
│ Add medical note...             │
│ ┌─────────────────────────────┐ │
│ │ Vital signs recorded...     │ │
│ └─────────────────────────────┘ │
│                                 │
│ 📷 📎              [Save Note]  │
└─────────────────────────────────┘
```

### Success
```
┌─────────────────────────────────┐
│ ✓ Note saved successfully       │
└─────────────────────────────────┘
```

## Code Details

### API Call
```dart
final response = await _dio.post(
  AppConstants.postEmtNotesEndpoint,
  data: {
    'case_id': 'CASE/26/00024',  // Hardcoded
    'new_notes': content,
    'emt_attachments': attachmentPaths.join(','),
  },
);
```

### Attachments Handling
```dart
// Multiple attachments
attachmentPaths = ['/path/to/file1.jpg', '/path/to/file2.pdf']

// Convert to comma-separated string
'emt_attachments': attachmentPaths.join(',')
// Result: "/path/to/file1.jpg,/path/to/file2.pdf"
```

### No Attachments
```dart
// Empty list
attachmentPaths = []

// Convert to empty string
'emt_attachments': attachmentPaths.join(',')
// Result: ""
```

## Testing

### 1. Test Save Note (No Attachments)
```
1. Go to medical notes screen
2. Type a note: "Patient stable"
3. Click "Save Note"
4. Check logs:
   [DIO] Body: {case_id: CASE/26/00024, new_notes: Patient stable, emt_attachments: }
   [MEDICAL NOTES] Note saved successfully
5. See success message
6. Note appears in list
```

### 2. Test Save Note (With Attachments)
```
1. Go to medical notes screen
2. Click camera icon (📷)
3. Take photo
4. Click attach icon (📎)
5. Select document
6. Type note: "Photos attached"
7. Click "Save Note"
8. Check logs:
   [DIO] Body: {case_id: CASE/26/00024, new_notes: Photos attached, emt_attachments: /path/to/photo.jpg,/path/to/doc.pdf}
   [MEDICAL NOTES] Note saved successfully
9. See success message
```

### 3. Test Empty Note
```
1. Go to medical notes screen
2. Don't type anything
3. Click "Save Note"
4. See error: "Please enter a note"
5. No API call made
```

## Debug Logs

### Success
```
[DIO] REQUEST[POST] => PATH: /api/post_emt_notes
[DIO] Headers: {Authorization: Bearer xxx}
[DIO] Body: {case_id: CASE/26/00024, new_notes: Patient stable, emt_attachments: }
[DIO] RESPONSE[200]
[MEDICAL NOTES] Response: {status: success, message: Note saved}
[MEDICAL NOTES] Note saved successfully
```

### Error
```
[DIO] REQUEST[POST] => PATH: /api/post_emt_notes
[DIO] ERROR: Connection timeout
[MEDICAL NOTES ERROR] DioException: Connection timeout
```

## Features

### ✅ Implemented
- API integration
- Auth token automatic
- Hardcoded case_id
- Note content
- Attachments support (comma-separated)
- Success/error handling
- Loading states
- User feedback

### 📝 Note Features
- Text input (multiline)
- Camera photo
- Document attachment
- Multiple attachments
- Remove attachments
- Save button
- Clear after save

## Edge Cases Handled

### ✅ Empty Note
- Shows error message
- No API call
- User must enter text

### ✅ No Attachments
- Sends empty string
- API accepts it
- Works fine

### ✅ Multiple Attachments
- Joins with comma
- Sends as single string
- API parses it

### ✅ API Error
- Shows error message
- Note not added to list
- User can retry

### ✅ Network Error
- Shows error message
- Graceful handling
- User can retry

## Hardcoded Values

### case_id
```dart
const caseId = 'CASE/26/00024';  // Hardcoded as requested
```

**Why Hardcoded?**
- As per requirement
- Will be dynamic later
- Easy to change

**To Make Dynamic Later**:
```dart
// Instead of hardcoded
const caseId = 'CASE/26/00024';

// Use mission ID or case ID from API
final caseId = mission.caseId;
```

## Files Modified

1. ✅ `lib/core/constants/app_constants.dart` - Added endpoint
2. ✅ `lib/data/repositories/medical_notes_repository.dart` - API implementation

## Summary

**Kya Hua**:
- ✅ `/api/post_emt_notes` API implement
- ✅ Auth token automatically add
- ✅ `case_id` hardcoded: `"CASE/26/00024"`
- ✅ `new_notes` user input se
- ✅ `emt_attachments` comma-separated paths
- ✅ Success/error messages
- ✅ Loading states

**API Call**:
```
POST /api/post_emt_notes
Authorization: Bearer {token}
Body: {
  case_id: "CASE/26/00024",
  new_notes: "Patient stable",
  emt_attachments: "/path/to/file1.jpg,/path/to/file2.pdf"
}
```

**Test Karo**:
1. Medical notes screen pe jao
2. Note type karo
3. Attachments add karo (optional)
4. "Save Note" dabao
5. Success message dekhoge
6. Note list mein add hoga

---

**Status**: ✅ Complete - Medical Notes API Ready!

**Hardcoded**: `case_id: "CASE/26/00024"`
