import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/user_model.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/app_constants.dart';
import 'dart:convert';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(secureStorageServiceProvider),
    ref.read(dioClientProvider),
  );
});

class AuthRepository {
  final SecureStorageService _storage;
  final Dio _dio;

  AuthRepository(this._storage, this._dio);

  /// Login with actual API call
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dio.post(
        AppConstants.loginEndpoint,
        data: {'login': email, 'password': password},
      );

      // Check if response is successful
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;

        // Handle your API response structure
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];

          // Extract all fields from response
          final sessionToken = data['session_token']?.toString() ?? '';
          final userId = data['user_id'] as int? ?? 0;
          final userName = data['user_name']?.toString() ?? email.split('@')[0];
          final companyId = data['company_id'] as int? ?? 0;
          final isEmt = data['is_emt'] as bool? ?? false;
          final isDriver = data['is_driver'] as bool? ?? false;
          final expiryTime = data['expiry_time']?.toString() ?? '';
          final mySchedule = jsonEncode(data['my_schedule'] ?? []);

          // Handle pending_login - can be int or bool
          int pendingLogin = 0;
          if (data['pending_login'] != null) {
            if (data['pending_login'] is int) {
              pendingLogin = data['pending_login'] as int;
            } else if (data['pending_login'] is bool) {
              pendingLogin = (data['pending_login'] as bool) ? 1 : 0;
            }
          }

          // Determine role based on is_emt and is_driver flags
          UserRole role = UserRole.emt;
          if (isEmt) {
            role = UserRole.emt;
          } else if (isDriver) {
            role = UserRole.emt; // Use EMT for driver as well
          }

          // Create user model
          final user = UserModel(
            id: userId.toString(),
            name: userName,
            email: email,
            employeeId: userId.toString(),
            role: role,
            phone: data['phone']?.toString(),
            avatar: data['avatar']?.toString(),
          );

          // Save all login data to secure storage
          await _storage.saveLoginData(
            sessionToken: sessionToken,
            userId: userId,
            userName: userName,
            companyId: companyId,
            isEmt: isEmt,
            isDriver: isDriver,
            expiryTime: expiryTime,
            mySchedule: mySchedule,
            pendingLogin: pendingLogin,
          );

          // Also save user model for backward compatibility
          await _storage.saveUserData(jsonEncode(user.toJson()));

          if (kDebugMode) {
            debugPrint(
              '[AUTH] Login successful - Token: $sessionToken, User ID: $userId, Name: $userName',
            );
            debugPrint(
              '[AUTH] Company ID: $companyId, Is EMT: $isEmt, Is Driver: $isDriver',
            );
            debugPrint(
              '[AUTH] Expiry: $expiryTime, Pending Login: $pendingLogin',
            );
          }

          return user;
        } else {
          throw Exception(responseData['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Login failed: Invalid response');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[AUTH ERROR] DioException: ${e.message}');
      }
      if (e.response != null) {
        if (kDebugMode) {
          debugPrint('[AUTH ERROR] Response data: ${e.response!.data}');
        }
        final errorMessage =
            e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Login failed';
        throw Exception(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server is taking too long to respond.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AUTH ERROR] Exception: $e');
      }
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    final userData = await _storage.getUserData();
    if (userData == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(userData));
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user with API call
  Future<void> logout() async {
    try {
      // Call logout API with token
      await _dio.post(AppConstants.logoutEndpoint);

      if (kDebugMode) {
        debugPrint('[AUTH] Logout API called successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AUTH] Logout API error: $e');
      }
      // Continue with local logout even if API fails
    } finally {
      // Always clear local storage
      await _storage.clearAll();
      if (kDebugMode) {
        debugPrint('[AUTH] Local storage cleared');
      }
    }
  }

  /// Refresh token (if your API supports it)
  Future<void> refreshToken() async {
    try {
      final currentToken = await _storage.getToken();
      if (currentToken == null) return;

      final response = await _dio.post(
        '/api/refresh-token',
        data: {'token': currentToken},
      );

      if (response.statusCode == 200) {
        final newToken =
            response.data['token'] ?? response.data['access_token'];
        await _storage.saveToken(newToken);
      }
    } catch (e) {
      // If refresh fails, user needs to login again
      await logout();
    }
  }
}
