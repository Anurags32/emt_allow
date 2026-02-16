import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/ambulance_model.dart';
import '../../../../data/repositories/ambulance_repository.dart';

class AmbulanceState {
  final AmbulanceModel? ambulance;
  final bool isLoading;
  final String? error;

  AmbulanceState({this.ambulance, this.isLoading = false, this.error});

  AmbulanceState copyWith({
    AmbulanceModel? ambulance,
    bool? isLoading,
    String? error,
  }) {
    return AmbulanceState(
      ambulance: ambulance ?? this.ambulance,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AmbulanceNotifier extends StateNotifier<AmbulanceState> {
  final AmbulanceRepository _ambulanceRepository;

  AmbulanceNotifier(this._ambulanceRepository) : super(AmbulanceState()) {
    loadAssignedAmbulance();
  }

  Future<void> loadAssignedAmbulance() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ambulance = await _ambulanceRepository.getAssignedAmbulance();
      state = state.copyWith(ambulance: ambulance, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final ambulanceProvider =
    StateNotifierProvider<AmbulanceNotifier, AmbulanceState>((ref) {
      return AmbulanceNotifier(ref.read(ambulanceRepositoryProvider));
    });
