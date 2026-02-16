// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyChecklistModel _$DailyChecklistModelFromJson(Map<String, dynamic> json) =>
    DailyChecklistModel(
      id: json['id'] as String,
      ambulanceId: json['ambulanceId'] as String,
      userId: json['userId'] as String,
      checkDate: DateTime.parse(json['checkDate'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$DailyChecklistModelToJson(
  DailyChecklistModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'ambulanceId': instance.ambulanceId,
  'userId': instance.userId,
  'checkDate': instance.checkDate.toIso8601String(),
  'items': instance.items,
  'isCompleted': instance.isCompleted,
  'notes': instance.notes,
};

ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    ChecklistItem(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      isRequired: json['isRequired'] as bool? ?? true,
      isChecked: json['isChecked'] as bool? ?? false,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ChecklistItemToJson(ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'isRequired': instance.isRequired,
      'isChecked': instance.isChecked,
      'notes': instance.notes,
    };
