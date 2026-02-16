import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/daily_checklist_model.dart';

class ChecklistNotifier extends StateNotifier<AsyncValue<DailyChecklistModel>> {
  final String ambulanceId;

  ChecklistNotifier(this.ambulanceId) : super(const AsyncValue.loading()) {
    loadChecklist();
  }

  Future<void> loadChecklist() async {
    state = const AsyncValue.loading();

    try {
      // TODO: Load from API based on ambulance type
      await Future.delayed(const Duration(seconds: 1));

      // Mock checklist
      final checklist = DailyChecklistModel(
        id: 'check_001',
        ambulanceId: ambulanceId,
        userId: 'user_001',
        checkDate: DateTime.now(),
        items: [
          ChecklistItem(
            id: 'item_001',
            name: 'Oxygen Tank (Full)',
            category: 'Medical Equipment',
            isRequired: true,
            isChecked: false,
          ),
          ChecklistItem(
            id: 'item_002',
            name: 'Defibrillator',
            category: 'Medical Equipment',
            isRequired: true,
            isChecked: false,
          ),
          ChecklistItem(
            id: 'item_003',
            name: 'First Aid Kit',
            category: 'Medical Equipment',
            isRequired: true,
            isChecked: false,
          ),
          ChecklistItem(
            id: 'item_004',
            name: 'Fire Extinguisher',
            category: 'Safety Equipment',
            isRequired: true,
            isChecked: false,
          ),
          ChecklistItem(
            id: 'item_005',
            name: 'Fuel Level',
            category: 'Vehicle',
            isRequired: true,
            isChecked: false,
          ),
          ChecklistItem(
            id: 'item_006',
            name: 'Radio Communication',
            category: 'Communication',
            isRequired: true,
            isChecked: false,
          ),
        ],
      );

      state = AsyncValue.data(checklist);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void toggleItem(String itemId) {
    state.whenData((checklist) {
      final updatedItems = checklist.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isChecked: !item.isChecked);
        }
        return item;
      }).toList();

      state = AsyncValue.data(
        DailyChecklistModel(
          id: checklist.id,
          ambulanceId: checklist.ambulanceId,
          userId: checklist.userId,
          checkDate: checklist.checkDate,
          items: updatedItems,
          isCompleted: checklist.isCompleted,
          notes: checklist.notes,
        ),
      );
    });
  }

  Future<bool> submitChecklist() async {
    try {
      // TODO: Submit to API
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}

final checklistProvider =
    StateNotifierProvider.family<
      ChecklistNotifier,
      AsyncValue<DailyChecklistModel>,
      String
    >((ref, ambulanceId) {
      return ChecklistNotifier(ambulanceId);
    });
