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
      createdAt: _dateTimeFromJson(json['createdAt']),
      lastActive: _dateTimeFromJsonNullable(json['lastActive']),
      schedule: _dateTimeFromJsonNullable(json['schedule']),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NoteModelToJson(_NoteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creatorId': instance.creatorId,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
      'schedule': instance.schedule?.toIso8601String(),
      'tags': instance.tags,
    };
