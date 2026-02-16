import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/ambulance/presentation/screens/ambulance_assignment_screen.dart';
import '../../features/mission/presentation/screens/mission_details_screen.dart';
import '../../features/patient/presentation/screens/patient_details_screen.dart';
import '../../features/medical_notes/presentation/screens/medical_notes_screen.dart';
import '../../features/handover/presentation/screens/patient_handover_screen.dart';
import '../../features/mission/presentation/screens/mission_completed_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/ambulance-assignment',
        name: 'ambulance-assignment',
        builder: (context, state) => const AmbulanceAssignmentScreen(),
      ),
      GoRoute(
        path: '/mission-details/:missionId',
        name: 'mission-details',
        builder: (context, state) {
          final missionId = state.pathParameters['missionId']!;
          return MissionDetailsScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: '/patient-details/:missionId',
        name: 'patient-details',
        builder: (context, state) {
          final missionId = state.pathParameters['missionId']!;
          return PatientDetailsScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: '/medical-notes/:missionId',
        name: 'medical-notes',
        builder: (context, state) {
          final missionId = state.pathParameters['missionId']!;
          return MedicalNotesScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: '/patient-handover/:missionId',
        name: 'patient-handover',
        builder: (context, state) {
          final missionId = state.pathParameters['missionId']!;
          return PatientHandoverScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: '/mission-completed/:missionId',
        name: 'mission-completed',
        builder: (context, state) {
          final missionId = state.pathParameters['missionId']!;
          return MissionCompletedScreen(missionId: missionId);
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
