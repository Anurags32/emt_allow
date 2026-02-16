import 'package:json_annotation/json_annotation.dart';

part 'medical_note_model.g.dart';

enum AttachmentType {
  @JsonValue('image')
  image,
  @JsonValue('document')
  document,
}

@JsonSerializable()
class MedicalNoteModel {
  final String id;
  final String missionId;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String content;
  final List<Attachment> attachments;
  final DateTime createdAt;

  MedicalNoteModel({
    required this.id,
    required this.missionId,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    required this.content,
    this.attachments = const [],
    required this.createdAt,
  });

  factory MedicalNoteModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalNoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalNoteModelToJson(this);
}

@JsonSerializable()
class Attachment {
  final String id;
  final String fileName;
  final AttachmentType type;
  final String url;
  final int? fileSize;

  Attachment({
    required this.id,
    required this.fileName,
    required this.type,
    required this.url,
    this.fileSize,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
