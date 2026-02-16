import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/medical_note_model.dart';

final medicalNotesRepositoryProvider = Provider<MedicalNotesRepository>((ref) {
  return MedicalNotesRepository();
});

class MedicalNotesRepository {
  // TODO: Replace with actual Odoo API call
  Future<List<MedicalNoteModel>> getNotesByMissionId(String missionId) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      MedicalNoteModel(
        id: 'note_001',
        missionId: missionId,
        authorId: '1',
        authorName: 'John Doe',
        authorRole: 'EMT',
        content:
            'Patient found conscious, complaining of chest pain. Vital signs stable.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        attachments: [],
      ),
      MedicalNoteModel(
        id: 'note_002',
        missionId: missionId,
        authorId: '1',
        authorName: 'John Doe',
        authorRole: 'EMT',
        content: 'Administered oxygen. Patient responding well.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        attachments: [],
      ),
    ];
  }

  Future<MedicalNoteModel> createNote({
    required String missionId,
    required String content,
    List<String> attachmentPaths = const [],
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Upload attachments and create note via API
    return MedicalNoteModel(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      missionId: missionId,
      authorId: '1',
      authorName: 'John Doe',
      authorRole: 'EMT',
      content: content,
      createdAt: DateTime.now(),
      attachments: [],
    );
  }

  Future<String> uploadAttachment(String filePath) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Implement file upload to Odoo
    return 'https://example.com/uploads/${DateTime.now().millisecondsSinceEpoch}';
  }
}
