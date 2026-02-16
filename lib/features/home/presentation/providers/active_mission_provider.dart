import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/mission_model.dart';
import '../../../../data/repositories/mission_repository.dart';

class ActiveMissionState {
  final MissionModel? mission;
  final bool isLoading;
  final String? error;

  ActiveMissionState({this.mission, this.isLoading = false, this.error});

  ActiveMissionState copyWith({
    MissionModel? mission,
    bool? isLoading,
    String? error,
  }) {
    return ActiveMissionState(
      mission: mission ?? this.mission,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ActiveMissionNotifier extends StateNotifier<ActiveMissionState> {
  final MissionRepository _missionRepository;

  ActiveMissionNotifier(this._missionRepository) : super(ActiveMissionState()) {
    loadActiveMission();
  }

  Future<void> loadActiveMission() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final mission = await _missionRepository.getActiveMission();
      state = state.copyWith(mission: mission, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearMission() {
    state = ActiveMissionState();
  }
}

final activeMissionProvider =
    StateNotifierProvider<ActiveMissionNotifier, ActiveMissionState>((ref) {
      return ActiveMissionNotifier(ref.read(missionRepositoryProvider));
    });
