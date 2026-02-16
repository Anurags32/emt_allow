// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalNoteModel _$MedicalNoteModelFromJson(Map<String, dynamic> json) =>
    MedicalNoteModel(
      id: json['id'] as String,
      missionId: json['missionId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String,
      content: json['content'] as String,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$MedicalNoteModelToJson(MedicalNoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'missionId': instance.missionId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorRole': instance.authorRole,
      'content': instance.content,
      'attachments': instance.attachments,
      'createdAt': instance.createdAt.toIso8601String(),
    };

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
  id: json['id'] as String,
  fileName: json['fileName'] as String,
  type: $enumDecode(_$AttachmentTypeEnumMap, json['type']),
  url: json['url'] as String,
  fileSize: (json['fileSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'type': _$AttachmentTypeEnumMap[instance.type]!,
      'url': instance.url,
      'fileSize': instance.fileSize,
    };

const _$AttachmentTypeEnumMap = {
  AttachmentType.image: 'image',
  AttachmentType.document: 'document',
};
