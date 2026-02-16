import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/assessment_model.dart';

class AssessmentNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final String missionId;

  AssessmentNotifier(this.missionId) : super(const AsyncValue.loading()) {
    loadAssessment();
  }

  Future<void> loadAssessment() async {
    state = const AsyncValue.loading();

    try {
      // TODO: Load from API
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      final questions = [
        AssessmentQuestion(
          id: 'q1',
          question: 'Patient conscious?',
          type: 'yes_no',
          isRequired: true,
          category: 'Initial Assessment',
        ),
        AssessmentQuestion(
          id: 'q2',
          question: 'Breathing normally?',
          type: 'yes_no',
          isRequired: true,
          category: 'Vital Signs',
        ),
        AssessmentQuestion(
          id: 'q3',
          question: 'Pain level (1-10)',
          type: 'number',
          isRequired: true,
          category: 'Symptoms',
        ),
        AssessmentQuestion(
          id: 'q4',
          question: 'Additional observations',
          type: 'text',
          isRequired: false,
          category: 'Notes',
        ),
      ];

      // Mock call center assessment
      final callCenterAssessment = AssessmentModel(
        id: 'assess_001',
        missionId: missionId,
        patientId: 'patient_001',
        source: AssessmentSource.callCenter,
        authorId: 'cc_001',
        authorName: 'Call Center Operator',
        answers: [
          AssessmentAnswer(
            questionId: 'q1',
            question: 'Patient conscious?',
            answer: 'Yes',
          ),
          AssessmentAnswer(
            questionId: 'q2',
            question: 'Breathing normally?',
            answer: 'No - difficulty breathing',
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      );

      state = AsyncValue.data({
        'questions': questions,
        'callCenterAssessment': callCenterAssessment,
        'emtAssessment': null,
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> submitEMTAssessment(Map<String, String> answers) async {
    try {
      // TODO: Submit to API
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}

final assessmentProvider =
    StateNotifierProvider.family<
      AssessmentNotifier,
      AsyncValue<Map<String, dynamic>>,
      String
    >((ref, missionId) {
      return AssessmentNotifier(missionId);
    });
