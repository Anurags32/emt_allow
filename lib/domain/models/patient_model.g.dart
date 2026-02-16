// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) => PatientModel(
  id: json['id'] as String,
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  phone: json['phone'] as String?,
  emergencyDescription: json['emergencyDescription'] as String,
  questionnaire:
      (json['questionnaire'] as List<dynamic>?)
          ?.map((e) => QuestionAnswer.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  bloodType: json['bloodType'] as String?,
  allergies: (json['allergies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  medications: (json['medications'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'gender': _$GenderEnumMap[instance.gender]!,
      'phone': instance.phone,
      'emergencyDescription': instance.emergencyDescription,
      'questionnaire': instance.questionnaire,
      'bloodType': instance.bloodType,
      'allergies': instance.allergies,
      'medications': instance.medications,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

QuestionAnswer _$QuestionAnswerFromJson(Map<String, dynamic> json) =>
    QuestionAnswer(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );

Map<String, dynamic> _$QuestionAnswerToJson(QuestionAnswer instance) =>
    <String, dynamic>{'question': instance.question, 'answer': instance.answer};
