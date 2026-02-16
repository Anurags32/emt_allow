import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/clock_in_repository.dart';

class ClockInState {
  final bool isClockedIn;
  final String? ambulanceId;
  final bool isLoading;
  final String? error;

  ClockInState({
    this.isClockedIn = false,
    this.ambulanceId,
    this.isLoading = false,
    this.error,
  });

  ClockInState copyWith({
    bool? isClockedIn,
    String? ambulanceId,
    bool? isLoading,
    String? error,
  }) {
    return ClockInState(
      isClockedIn: isClockedIn ?? this.isClockedIn,
      ambulanceId: ambulanceId ?? this.ambulanceId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ClockInNotifier extends StateNotifier<ClockInState> {
  final ClockInRepository _repository;

  ClockInNotifier(this._repository) : super(ClockInState());

  Future<bool> clockIn(String ambulanceId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Call API to clock in
      await _repository.clockIn(ambulanceId);

      state = state.copyWith(
        isClockedIn: true,
        ambulanceId: ambulanceId,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> clockOut() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Call API to clock out
      await _repository.clockOut();

      state = ClockInState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkClockInStatus() async {
    try {
      final clockInData = await _repository.getClockInStatus();

      if (clockInData != null) {
        state = state.copyWith(
          isClockedIn: true,
          ambulanceId: clockInData.ambulanceId,
        );
      }
    } catch (e) {
      // Ignore errors when checking status
    }
  }
}

final clockInProvider = StateNotifierProvider<ClockInNotifier, ClockInState>((
  ref,
) {
  return ClockInNotifier(ref.read(clockInRepositoryProvider));
});
