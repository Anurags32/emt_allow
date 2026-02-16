import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/clock_in_model.dart';

class TeamSelectionState {
  final List<TeamMember> availableDoctors;
  final List<TeamMember> availableNurses;
  final bool isLoading;
  final String? error;

  TeamSelectionState({
    this.availableDoctors = const [],
    this.availableNurses = const [],
    this.isLoading = false,
    this.error,
  });

  TeamSelectionState copyWith({
    List<TeamMember>? availableDoctors,
    List<TeamMember>? availableNurses,
    bool? isLoading,
    String? error,
  }) {
    return TeamSelectionState(
      availableDoctors: availableDoctors ?? this.availableDoctors,
      availableNurses: availableNurses ?? this.availableNurses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TeamSelectionNotifier extends StateNotifier<TeamSelectionState> {
  TeamSelectionNotifier() : super(TeamSelectionState()) {
    loadTeamMembers();
  }

  Future<void> loadTeamMembers() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Load from API
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final doctors = [
        TeamMember(
          id: 'doc_001',
          name: 'Dr. Sarah Johnson',
          role: 'Doctor',
          employeeId: 'DOC001',
          isAvailable: true,
        ),
        TeamMember(
          id: 'doc_002',
          name: 'Dr. Michael Chen',
          role: 'Doctor',
          employeeId: 'DOC002',
          isAvailable: true,
        ),
      ];

      final nurses = [
        TeamMember(
          id: 'nurse_001',
          name: 'Emily Davis',
          role: 'Nurse',
          employeeId: 'NUR001',
          isAvailable: true,
        ),
        TeamMember(
          id: 'nurse_002',
          name: 'James Wilson',
          role: 'Nurse',
          employeeId: 'NUR002',
          isAvailable: true,
        ),
      ];

      state = state.copyWith(
        availableDoctors: doctors,
        availableNurses: nurses,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> assignTeam(
    String ambulanceId,
    String doctorId,
    String nurseId,
  ) async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Call API to assign team
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final teamSelectionProvider =
    StateNotifierProvider<TeamSelectionNotifier, TeamSelectionState>((ref) {
      return TeamSelectionNotifier();
    });
