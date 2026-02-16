import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/patient_model.dart';

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepository();
});

class PatientRepository {
  // TODO: Replace with actual Odoo API call
  Future<PatientModel> getPatientByMissionId(String missionId) async {
    await Future.delayed(const Duration(seconds: 1));

    return PatientModel(
      id: 'patient_001',
      name: 'Jane Smith',
      age: 45,
      gender: Gender.female,
      phone: '+1234567893',
      emergencyDescription:
          'Chest pain and difficulty breathing for 30 minutes',
      bloodType: 'O+',
      allergies: ['Penicillin', 'Peanuts'],
      medications: ['Aspirin 81mg daily', 'Lisinopril 10mg'],
      questionnaire: [
        QuestionAnswer(
          question: 'When did symptoms start?',
          answer: 'Approximately 30 minutes ago',
        ),
        QuestionAnswer(
          question: 'Any previous cardiac history?',
          answer: 'Yes, had a heart attack 2 years ago',
        ),
        QuestionAnswer(
          question: 'Current medications?',
          answer: 'Aspirin and blood pressure medication',
        ),
      ],
    );
  }
}
