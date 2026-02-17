import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../domain/models/medical_note_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/secure_storage_service.dart';

final medicalNotesRepositoryProvider = Provider<MedicalNotesRepository>((ref) {
  return MedicalNotesRepository(
    ref.read(dioClientProvider),
    ref.read(secureStorageServiceProvider),
  );
});

class MedicalNotesRepository {
  final Dio _dio;
  final SecureStorageService _storage;

  MedicalNotesRepository(this._dio, this._storage);

  Future<List<MedicalNoteModel>> getNotesByMissionId(
    String missionId, {
    String? caseId,
  }) async {
    try {
      // Get user_id from storage
      final userId = await _storage.getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }

      // Use provided case_id or default
      final finalCaseId = caseId ?? 'CASE/26/00024';

      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES] Fetching notes:');
        debugPrint('[MEDICAL NOTES] User ID: $userId');
        debugPrint('[MEDICAL NOTES] Case ID: $finalCaseId');
      }

      // Call GET API with body
      final response = await _dio.get(
        AppConstants.getEmtNotesEndpoint,
        data: {'user_id': int.parse(userId), 'case_id': finalCaseId},
      );

      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES] Response: ${response.data}');
      }

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          final emtNotes = data['emt_notes']?.toString() ?? '';
          final attachmentsList =
              data['emt_attachments'] as List<dynamic>? ?? [];

          if (kDebugMode) {
            debugPrint('[MEDICAL NOTES] Notes: $emtNotes');
            debugPrint(
              '[MEDICAL NOTES] Attachments count: ${attachmentsList.length}',
            );
          }

          // Parse attachments
          final List<Attachment> attachments = [];
          for (var attachmentData in attachmentsList) {
            try {
              final id = attachmentData['id']?.toString() ?? '';
              final filename = attachmentData['filename']?.toString() ?? '';
              final mimetype = attachmentData['mimetype']?.toString() ?? '';
              final fileData = attachmentData['file_data']?.toString() ?? '';

              // Determine attachment type from mimetype
              AttachmentType type = AttachmentType.document;
              if (mimetype.startsWith('image/')) {
                type = AttachmentType.image;
              } else if (mimetype.startsWith('video/')) {
                type = AttachmentType.document; // Treat video as document
              }

              // Create data URL from base64
              final dataUrl = 'data:$mimetype;base64,$fileData';

              attachments.add(
                Attachment(
                  id: id,
                  fileName: filename,
                  type: type,
                  url: dataUrl,
                  fileSize: null,
                ),
              );

              if (kDebugMode) {
                debugPrint(
                  '[MEDICAL NOTES] Parsed attachment: $filename ($mimetype)',
                );
              }
            } catch (e) {
              if (kDebugMode) {
                debugPrint('[MEDICAL NOTES] Error parsing attachment: $e');
              }
            }
          }

          // Return single note with all content
          if (emtNotes.isNotEmpty || attachments.isNotEmpty) {
            return [
              MedicalNoteModel(
                id: 'note_${DateTime.now().millisecondsSinceEpoch}',
                missionId: missionId,
                authorId: userId,
                authorName: await _storage.getUserName() ?? 'EMT',
                authorRole: 'EMT',
                content: emtNotes.isNotEmpty ? emtNotes : 'No notes',
                createdAt: DateTime.now(),
                attachments: attachments,
              ),
            ];
          }

          return [];
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch notes');
        }
      } else {
        throw Exception('Failed to fetch notes');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES ERROR] ${e.message}');
        if (e.response != null) {
          debugPrint('[MEDICAL NOTES ERROR] Response: ${e.response!.data}');
        }
      }
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch notes: ${e.message}',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES ERROR] $e');
      }
      throw Exception('Failed to fetch notes: ${e.toString()}');
    }
  }

  Future<MedicalNoteModel> createNote({
    required String missionId,
    required String content,
    required String caseId,
    List<String> attachmentPaths = const [],
  }) async {
    try {
      // Get user_id from storage
      final userId = await _storage.getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }

      // Prepare FormData with files
      final formData = FormData.fromMap({
        'user_id': userId,
        'case_id': caseId,
        'new_notes': content,
      });

      // Add files to FormData
      if (attachmentPaths.isNotEmpty) {
        if (kDebugMode) {
          debugPrint('[MEDICAL NOTES] Adding ${attachmentPaths.length} files');
        }

        for (var i = 0; i < attachmentPaths.length; i++) {
          final path = attachmentPaths[i];
          try {
            final file = File(path);
            if (await file.exists()) {
              final fileName = path.split('/').last;
              formData.files.add(
                MapEntry(
                  'emt_attachments',
                  await MultipartFile.fromFile(path, filename: fileName),
                ),
              );
              if (kDebugMode) {
                debugPrint('[MEDICAL NOTES] Added file: $fileName');
              }
            } else {
              if (kDebugMode) {
                debugPrint('[MEDICAL NOTES] File not found: $path');
              }
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[MEDICAL NOTES] Error adding file $path: $e');
            }
          }
        }
      }

      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES] Sending FormData request:');
        debugPrint('[MEDICAL NOTES] User ID: $userId');
        debugPrint('[MEDICAL NOTES] Case ID: $caseId');
        debugPrint('[MEDICAL NOTES] Notes: $content');
        debugPrint('[MEDICAL NOTES] Files count: ${formData.files.length}');
      }

      // Call API with FormData
      final response = await _dio.post(
        AppConstants.postEmtNotesEndpoint,
        data: formData,
      );

      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES] Response: ${response.data}');
      }

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;

        if (responseData['status'] == 'success') {
          if (kDebugMode) {
            debugPrint('[MEDICAL NOTES] Note saved successfully');
          }

          // Return the created note
          return MedicalNoteModel(
            id: 'note_${DateTime.now().millisecondsSinceEpoch}',
            missionId: missionId,
            authorId: '1',
            authorName: 'Current User',
            authorRole: 'EMT',
            content: content,
            createdAt: DateTime.now(),
            attachments: [],
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to save note');
        }
      } else {
        throw Exception('Failed to save note');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES ERROR] ${e.message}');
        if (e.response != null) {
          debugPrint('[MEDICAL NOTES ERROR] Response: ${e.response!.data}');
        }
      }
      throw Exception(
        e.response?.data['message'] ?? 'Failed to save note: ${e.message}',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[MEDICAL NOTES ERROR] $e');
      }
      throw Exception('Failed to save note: ${e.toString()}');
    }
  }

  Future<String> uploadAttachment(String filePath) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Implement file upload to Odoo
    return 'https://example.com/uploads/${DateTime.now().millisecondsSinceEpoch}';
  }
}
