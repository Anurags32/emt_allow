import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/models/clock_in_model.dart';

final clockInRepositoryProvider = Provider<ClockInRepository>((ref) {
  return ClockInRepository(ref.read(dioClientProvider));
});

class ClockInRepository {
  final Dio _dio;

  ClockInRepository(this._dio);

  /// Clock in with API call
  Future<ClockInModel> clockIn(String ambulanceId) async {
    try {
      final response = await _dio.post(
        AppConstants.checkInEndpoint,
        data: {'ambulance_id': ambulanceId},
      );

      if (kDebugMode) {
        debugPrint('[CLOCK IN] Response: ${response.data}');
      }

      // Check if response is successful
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data;

        // Handle your API response structure
        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          final data = responseData['data'];

          // Create clock in model
          final clockIn = ClockInModel(
            id:
                data['id']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            userId:
                data['user_id']?.toString() ??
                data['employee_id']?.toString() ??
                '',
            ambulanceId: ambulanceId,
            status: ClockStatus.clockedIn,
            clockInTime: data['clock_in_time'] != null
                ? DateTime.parse(data['clock_in_time'])
                : DateTime.now(),
            isValidated: data['is_validated'] ?? true,
          );

          if (kDebugMode) {
            debugPrint('[CLOCK IN] Success - Ambulance: $ambulanceId');
          }

          return clockIn;
        } else {
          throw Exception(responseData['message'] ?? 'Clock in failed');
        }
      } else {
        throw Exception('Clock in failed: Invalid response');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[CLOCK IN ERROR] DioException: ${e.message}');
      }
      if (e.response != null) {
        if (kDebugMode) {
          debugPrint('[CLOCK IN ERROR] Response: ${e.response!.data}');
        }
        final errorMessage =
            e.response!.data['message'] ??
            e.response!.data['error'] ??
            'Clock in failed';
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
        debugPrint('[CLOCK IN ERROR] Exception: $e');
      }
      throw Exception('Clock in failed: ${e.toString()}');
    }
  }

  /// Clock out with API call
  Future<void> clockOut() async {
    try {
      final response = await _dio.post(
        '/api/check_out', // Assuming you have a check_out endpoint
        data: {},
      );

      if (kDebugMode) {
        debugPrint('[CLOCK OUT] Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint('[CLOCK OUT] Success');
        }
      } else {
        throw Exception('Clock out failed');
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[CLOCK OUT ERROR] ${e.message}');
      }
      throw Exception('Clock out failed: ${e.message}');
    }
  }

  /// Get clock in status
  Future<ClockInModel?> getClockInStatus() async {
    try {
      final response = await _dio.get('/api/clock_status');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];

        if (data != null && data['is_clocked_in'] == true) {
          return ClockInModel(
            id: data['id']?.toString() ?? '',
            userId: data['user_id']?.toString() ?? '',
            ambulanceId: data['ambulance_id']?.toString(),
            status: ClockStatus.clockedIn,
            clockInTime: data['clock_in_time'] != null
                ? DateTime.parse(data['clock_in_time'])
                : DateTime.now(),
            isValidated: data['is_validated'] ?? true,
          );
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CLOCK STATUS ERROR] $e');
      }
      return null;
    }
  }
}
