import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/patient_model.dart';
import '../../../../data/repositories/patient_repository.dart';

final patientProvider = FutureProvider.family<PatientModel, String>((
  ref,
  missionId,
) async {
  final repository = ref.read(patientRepositoryProvider);
  return await repository.getPatientByMissionId(missionId);
});
