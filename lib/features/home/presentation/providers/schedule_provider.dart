import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../../../domain/models/schedule_model.dart';
import '../../../../core/storage/secure_storage_service.dart';

final scheduleProvider = FutureProvider<List<ScheduleModel>>((ref) async {
  final storage = ref.watch(secureStorageServiceProvider);
  final scheduleJson = await storage.getSchedule();

  if (scheduleJson == null || scheduleJson.isEmpty) {
    return [];
  }

  try {
    final List<dynamic> scheduleList = jsonDecode(scheduleJson);
    return scheduleList
        .map((json) => ScheduleModel.fromJson(json as Map<String, dynamic>))
        .toList();
  } catch (e) {
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
