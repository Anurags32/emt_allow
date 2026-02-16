import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/mission_model.dart';
import '../../../../data/repositories/mission_repository.dart';

final missionDetailProvider = FutureProvider.family<MissionModel, String>((
  ref,
  missionId,
) async {
  final repository = ref.read(missionRepositoryProvider);
  return await repository.getMissionById(missionId);
});
