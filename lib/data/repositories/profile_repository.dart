import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/profile_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/secure_storage_service.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.read(dioClientProvider),
    ref.read(secureStorageServiceProvider),
  );
});

class ProfileRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ProfileRepository(this._dio, SecureStorageService storage);

  Future<ProfileModel> getProfileInfo() async {
    try {
      if (kDebugMode) {
        debugPrint('[PROFILE] Fetching profile info');
      }

      final response = await _dio.get(AppConstants.getProfileInfoEndpoint);

      if (kDebugMode) {
        debugPrint('[PROFILE] Response: ${response.data}');
      }

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];
          final profile = ProfileModel.fromJson(data);

          // Save name
          await _secureStorage.write(
            key: AppConstants.userNameKey,
            value: profile.name,
          );

          // Save profile image if available
          if (profile.profImg != null &&
              profile.profImg != 'No Image Found' &&
              profile.profImg!.isNotEmpty) {
            await _secureStorage.write(
              key: AppConstants.userImageKey,
              value: profile.profImg!,
            );

            if (kDebugMode) {
              final imageSize = profile.profImg!.length;
              debugPrint(
                '[PROFILE] Image data received: $imageSize chars (${(imageSize * 0.75).round()} bytes)',
              );
              if (imageSize < 50000) {
                debugPrint(
                  '[PROFILE] ⚠️ WARNING: Image data seems incomplete. Expected 50KB-200KB, got ${(imageSize * 0.75 / 1024).toStringAsFixed(1)}KB',
                );
              }
            }
          }

          // Update pending_login status
          await _secureStorage.write(
            key: AppConstants.pendingLoginKey,
            value: profile.pendingLogin ? '1' : '0',
          );

          if (kDebugMode) {
            debugPrint('[PROFILE] Profile saved: ${profile.name}');
            debugPrint('[PROFILE] Pending Login: ${profile.pendingLogin}');
          }

          return profile;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch profile');
        }
      } else {
        throw Exception('Failed to fetch profile');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[PROFILE ERROR] ${e.message}');
        if (e.response != null) {
          debugPrint('[PROFILE ERROR] Response: ${e.response!.data}');
        }
      }
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch profile: ${e.message}',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PROFILE ERROR] $e');
      }
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }
}
