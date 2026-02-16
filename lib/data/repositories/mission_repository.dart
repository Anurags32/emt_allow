import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/mission_model.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository();
});

class MissionRepository {
  // TODO: Replace with actual Odoo API call
  Future<MissionModel?> getActiveMission() async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock mission data
    return MissionModel(
      id: 'mission_001',
      missionNumber: 'MSN-2024-001',
      emergencyType: EmergencyType.cardiac,
      status: MissionStatus.assigned,
      patientId: 'patient_001',
      ambulanceId: 'amb_001',
      clinicId: 'clinic_001',
      clinicName: 'City General Hospital',
      clinicAddress: '123 Main St, City, State 12345',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      timeline: [
        MissionTimeline(
          status: MissionStatus.assigned,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          notes: 'Mission assigned to EMT team',
        ),
      ],
    );
  }

  Future<MissionModel> getMissionById(String missionId) async {
    await Future.delayed(const Duration(seconds: 1));

    return MissionModel(
      id: missionId,
      missionNumber: 'MSN-2024-001',
      emergencyType: EmergencyType.cardiac,
      status: MissionStatus.onScene,
      patientId: 'patient_001',
      ambulanceId: 'amb_001',
      clinicId: 'clinic_001',
      clinicName: 'City General Hospital',
      clinicAddress: '123 Main St, City, State 12345',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      timeline: [
        MissionTimeline(
          status: MissionStatus.assigned,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          notes: 'Mission assigned',
        ),
        MissionTimeline(
          status: MissionStatus.enRoute,
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          notes: 'En route to patient location',
        ),
        MissionTimeline(
          status: MissionStatus.onScene,
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          notes: 'Arrived at scene',
        ),
      ],
    );
  }

  Future<void> updateMissionStatus(
    String missionId,
    MissionStatus status,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Implement API call
  }

  Future<void> completeMission(String missionId) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Implement API call
  }
}
