// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => _NoteModel(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      status: $enumDecode(_$NoteStatusEnumMap, json['status'],
          unknownValue: NoteStatus.UNACTIVE),
      createdAt: DateTimeFromJson(json['createdAt']),
      updatedAt: DateTimeFromJsonNullable(json['updatedAt']),
      schedule: DateTimeFromJsonNullable(json['schedule']),
      tag: (json['tag'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NoteModelToJson(_NoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'title': instance.title,
      'content': instance.content,
      'status': _$NoteStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'schedule': instance.schedule?.toIso8601String(),
      'tag': instance.tag,
    };

const _$NoteStatusEnumMap = {
  NoteStatus.ACTIVE: 'ACTIVE',
  NoteStatus.UNACTIVE: 'UNACTIVE',
};
