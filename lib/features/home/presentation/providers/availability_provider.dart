import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/secure_storage_service.dart';

class AvailabilityState {
  final bool isOnline;
  final bool isLoading;
  final String? error;

  AvailabilityState({
    this.isOnline = false,
    this.isLoading = false,
    this.error,
  });

  AvailabilityState copyWith({bool? isOnline, bool? isLoading, String? error}) {
    return AvailabilityState(
      isOnline: isOnline ?? this.isOnline,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  final Dio _dio;
  final SecureStorageService _storage;

  AvailabilityNotifier(this._dio, this._storage) : super(AvailabilityState());

  Future<void> toggleAvailability() async {
    final newStatus = !state.isOnline;
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get user_id from storage
      final userId = await _storage.getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }

      // Call API with user_id and check_in
      final response = await _dio.post(
        AppConstants.checkInOutEndpoint,
        data: {'user_id': int.parse(userId), 'check_in': newStatus ? 1 : 0},
      );

      if (kDebugMode) {
        debugPrint('[AVAILABILITY] Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        state = state.copyWith(isOnline: newStatus, isLoading: false);

        if (kDebugMode) {
          debugPrint(
            '[AVAILABILITY] Status updated - User ID: $userId, Online: $newStatus',
          );
        }
      } else {
        throw Exception('Failed to update availability');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[AVAILABILITY ERROR] ${e.message}');
        if (e.response != null) {
          debugPrint('[AVAILABILITY ERROR] Response: ${e.response!.data}');
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['message'] ?? 'Failed to update availability',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AVAILABILITY ERROR] $e');
      }

      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setOnline(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }
}

final availabilityProvider =
    StateNotifierProvider<AvailabilityNotifier, AvailabilityState>((ref) {
      final dio = ref.watch(dioClientProvider);
      final storage = ref.watch(secureStorageServiceProvider);
      return AvailabilityNotifier(dio, storage);
    });
