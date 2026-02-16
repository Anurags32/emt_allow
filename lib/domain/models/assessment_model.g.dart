// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssessmentModel _$AssessmentModelFromJson(Map<String, dynamic> json) =>
    AssessmentModel(
      id: json['id'] as String,
      missionId: json['missionId'] as String,
      patientId: json['patientId'] as String,
      source: $enumDecode(_$AssessmentSourceEnumMap, json['source']),
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AssessmentAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssessmentModelToJson(AssessmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'missionId': instance.missionId,
      'patientId': instance.patientId,
      'source': _$AssessmentSourceEnumMap[instance.source]!,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'answers': instance.answers,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AssessmentSourceEnumMap = {
  AssessmentSource.callCenter: 'call_center',
  AssessmentSource.emt: 'emt',
};

AssessmentAnswer _$AssessmentAnswerFromJson(Map<String, dynamic> json) =>
    AssessmentAnswer(
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$AssessmentAnswerToJson(AssessmentAnswer instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'question': instance.question,
      'answer': instance.answer,
      'notes': instance.notes,
    };

AssessmentQuestion _$AssessmentQuestionFromJson(Map<String, dynamic> json) =>
    AssessmentQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      type: json['type'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isRequired: json['isRequired'] as bool? ?? true,
      category: json['category'] as String,
    );

Map<String, dynamic> _$AssessmentQuestionToJson(AssessmentQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'type': instance.type,
      'options': instance.options,
      'isRequired': instance.isRequired,
      'category': instance.category,
    };
