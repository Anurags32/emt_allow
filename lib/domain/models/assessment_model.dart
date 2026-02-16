import 'package:json_annotation/json_annotation.dart';

part 'assessment_model.g.dart';

enum AssessmentSource {
  @JsonValue('call_center')
  callCenter,
  @JsonValue('emt')
  emt,
}

@JsonSerializable()
class AssessmentModel {
  final String id;
  final String missionId;
  final String patientId;
  final AssessmentSource source;
  final String authorId;
  final String authorName;
  final List<AssessmentAnswer> answers;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AssessmentModel({
    required this.id,
    required this.missionId,
    required this.patientId,
    required this.source,
    required this.authorId,
    required this.authorName,
    required this.answers,
    required this.createdAt,
    this.updatedAt,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentModelToJson(this);
}

@JsonSerializable()
class AssessmentAnswer {
  final String questionId;
  final String question;
  final String answer;
  final String? notes;

  AssessmentAnswer({
    required this.questionId,
    required this.question,
    required this.answer,
    this.notes,
  });

  factory AssessmentAnswer.fromJson(Map<String, dynamic> json) =>
      _$AssessmentAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentAnswerToJson(this);
}

@JsonSerializable()
class AssessmentQuestion {
  final String id;
  final String question;
  final String type; // text, multiple_choice, yes_no, number
  final List<String>? options;
  final bool isRequired;
  final String category;

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    this.isRequired = true,
    required this.category,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) =>
      _$AssessmentQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentQuestionToJson(this);
}
