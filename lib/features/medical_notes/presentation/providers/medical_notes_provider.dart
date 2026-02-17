import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/medical_note_model.dart';
import '../../../../data/repositories/medical_notes_repository.dart';

class MedicalNotesNotifier
    extends StateNotifier<AsyncValue<List<MedicalNoteModel>>> {
  final MedicalNotesRepository _repository;
  final String _missionId;

  MedicalNotesNotifier(this._repository, this._missionId)
    : super(const AsyncValue.loading()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    state = const AsyncValue.loading();
    try {
      final notes = await _repository.getNotesByMissionId(_missionId);
      state = AsyncValue.data(notes);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> addNote(
    String content,
    List<String> attachmentPaths,
    String caseId,
  ) async {
    try {
      final note = await _repository.createNote(
        missionId: _missionId,
        content: content,
        caseId: caseId,
        attachmentPaths: attachmentPaths,
      );

      // Add new note to the list
      state.whenData((notes) {
        state = AsyncValue.data([...notes, note]);
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}

final medicalNotesProvider =
    StateNotifierProvider.family<
      MedicalNotesNotifier,
      AsyncValue<List<MedicalNoteModel>>,
      String
    >((ref, missionId) {
      return MedicalNotesNotifier(
        ref.read(medicalNotesRepositoryProvider),
        missionId,
      );
    });
