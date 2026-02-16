import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/mission_repository.dart';

final missionLockProvider = FutureProvider.family<bool, String>((
  ref,
  missionId,
) async {
  final repository = ref.read(missionRepositoryProvider);
  final mission = await repository.getMissionById(missionId);
  return mission.isLocked;
});
