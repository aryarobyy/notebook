
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
sealed class NoteModel with _$NoteModel {
  factory NoteModel({
    required String id,
    required String createdBy,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updateAt,
  }) = _NoteModel;

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);
}