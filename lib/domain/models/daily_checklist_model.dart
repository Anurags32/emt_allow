import 'package:json_annotation/json_annotation.dart';

part 'daily_checklist_model.g.dart';

@JsonSerializable()
class DailyChecklistModel {
  final String id;
  final String ambulanceId;
  final String userId;
  final DateTime checkDate;
  final List<ChecklistItem> items;
  final bool isCompleted;
  final String? notes;

  DailyChecklistModel({
    required this.id,
    required this.ambulanceId,
    required this.userId,
    required this.checkDate,
    required this.items,
    this.isCompleted = false,
    this.notes,
  });

  factory DailyChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$DailyChecklistModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyChecklistModelToJson(this);

  int get completedCount => items.where((item) => item.isChecked).length;
  int get totalCount => items.length;
  double get completionPercentage =>
      totalCount > 0 ? (completedCount / totalCount) * 100 : 0;
}

@JsonSerializable()
class ChecklistItem {
  final String id;
  final String name;
  final String category;
  final bool isRequired;
  final bool isChecked;
  final String? notes;

  ChecklistItem({
    required this.id,
    required this.name,
    required this.category,
    this.isRequired = true,
    this.isChecked = false,
    this.notes,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistItemToJson(this);

  ChecklistItem copyWith({
    String? id,
    String? name,
    String? category,
    bool? isRequired,
    bool? isChecked,
    String? notes,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isRequired: isRequired ?? this.isRequired,
      isChecked: isChecked ?? this.isChecked,
      notes: notes ?? this.notes,
    );
  }
}
