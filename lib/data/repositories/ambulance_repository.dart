import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/ambulance_model.dart';

final ambulanceRepositoryProvider = Provider<AmbulanceRepository>((ref) {
  return AmbulanceRepository();
});

class AmbulanceRepository {
  // TODO: Replace with actual Odoo API call
  Future<AmbulanceModel?> getAssignedAmbulance() async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock ambulance data
    return AmbulanceModel(
      id: 'amb_001',
      vehicleNumber: 'AMB-2024-001',
      type: AmbulanceType.advanced,
      status: AmbulanceStatus.assigned,
      driverName: 'Mike Johnson',
      driverPhone: '+1234567891',
    );
  }

  Future<List<AmbulanceModel>> getAvailableAmbulances() async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock list
    return [
      AmbulanceModel(
        id: 'amb_001',
        vehicleNumber: 'AMB-2024-001',
        type: AmbulanceType.advanced,
        status: AmbulanceStatus.available,
        driverName: 'Mike Johnson',
        driverPhone: '+1234567891',
      ),
      AmbulanceModel(
        id: 'amb_002',
        vehicleNumber: 'AMB-2024-002',
        type: AmbulanceType.basic,
        status: AmbulanceStatus.available,
        driverName: 'Sarah Williams',
        driverPhone: '+1234567892',
      ),
    ];
  }
}
