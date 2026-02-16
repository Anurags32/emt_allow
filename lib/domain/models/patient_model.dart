import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
}

@JsonSerializable()
class PatientModel {
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String? phone;
  final String emergencyDescription;
  final List<QuestionAnswer> questionnaire;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? medications;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.phone,
    required this.emergencyDescription,
    this.questionnaire = const [],
    this.bloodType,
    this.allergies,
    this.medications,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);

  String get genderDisplayName {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

@JsonSerializable()
class QuestionAnswer {
  final String question;
  final String answer;

  QuestionAnswer({required this.question, required this.answer});

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionAnswerToJson(this);
}
