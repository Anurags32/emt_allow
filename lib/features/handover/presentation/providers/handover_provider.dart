import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/mission_repository.dart';

class HandoverState {
  final bool isLoading;
  final String? error;

  HandoverState({this.isLoading = false, this.error});

  HandoverState copyWith({bool? isLoading, String? error}) {
    return HandoverState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HandoverNotifier extends StateNotifier<HandoverState> {
  final MissionRepository _missionRepository;

  HandoverNotifier(this._missionRepository) : super(HandoverState());

  Future<bool> submitHandover(String missionId, String remarks) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Call actual API to submit handover
      await Future.delayed(const Duration(seconds: 2));
      await _missionRepository.completeMission(missionId);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final handoverProvider = StateNotifierProvider<HandoverNotifier, HandoverState>(
  (ref) {
    return HandoverNotifier(ref.read(missionRepositoryProvider));
  },
);
