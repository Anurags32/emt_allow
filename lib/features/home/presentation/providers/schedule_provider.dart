import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../domain/models/schedule_model.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';

// Fetch schedule from API
final scheduleProvider = FutureProvider<List<ScheduleModel>>((ref) async {
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(secureStorageServiceProvider);

  try {
    // Get user_id from storage
    final userId = await storage.getUserId();

    if (userId == null || userId.isEmpty) {
      if (kDebugMode) {
        debugPrint('[SCHEDULE] User ID not found');
      }
      return [];
    }

    // Call API
    final response = await dio.get(
      AppConstants.getScheduleEndpoint,
      data: {'user_id': int.parse(userId)},
    );

    if (kDebugMode) {
      debugPrint('[SCHEDULE] Response: ${response.data}');
    }

    if (response.statusCode == 200 && response.data != null) {
      final responseData = response.data;

      if (responseData['status'] == 'success' && responseData['data'] != null) {
        final List<dynamic> scheduleList = responseData['data'];

        final schedules = scheduleList
            .map((json) => ScheduleModel.fromJson(json as Map<String, dynamic>))
            .toList();

        if (kDebugMode) {
          debugPrint('[SCHEDULE] Fetched ${schedules.length} schedules');
        }

        return schedules;
      }
    }

    return [];
  } on DioException catch (e) {
    if (kDebugMode) {
      debugPrint('[SCHEDULE ERROR] ${e.message}');
      if (e.response != null) {
        debugPrint('[SCHEDULE ERROR] Response: ${e.response!.data}');
      }
    }
    return [];
  } catch (e) {
    if (kDebugMode) {
      debugPrint('[SCHEDULE ERROR] $e');
    }
    return [];
  }
});

// Provider to get today's schedule
final todayScheduleProvider = FutureProvider<ScheduleModel?>((ref) async {
  final schedules = await ref.watch(scheduleProvider.future);

  if (schedules.isEmpty) return null;

  final today = DateTime.now();
  final todayStr =
      '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

  try {
    return schedules.firstWhere((schedule) => schedule.date == todayStr);
  } catch (e) {
    return null;
  }
});

// Provider to get upcoming schedules (next 7 days)
final upcomingSchedulesProvider = FutureProvider<List<ScheduleModel>>((
  ref,
) async {
  final schedules = await ref.watch(scheduleProvider.future);

  if (schedules.isEmpty) return [];

  final today = DateTime.now();
  final next7Days = today.add(const Duration(days: 7));

  return schedules.where((schedule) {
    try {
      final parts = schedule.date.split('/');
      if (parts.length != 3) return false;

      final scheduleDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      return scheduleDate.isAfter(today.subtract(const Duration(days: 1))) &&
          scheduleDate.isBefore(next7Days);
    } catch (e) {
      return false;
    }
  }).toList();
});
