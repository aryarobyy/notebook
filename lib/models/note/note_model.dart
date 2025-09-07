import '../date_time.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@JsonEnum()
enum NoteStatus {
  @JsonValue('ACTIVE')
  ACTIVE,
  @JsonValue('UNACTIVE')
  UNACTIVE,
}

@freezed
sealed class NoteModel with _$NoteModel {
  factory NoteModel({
    required String id,
    required String creatorId,
    required String title,
    required String content,
    @JsonKey(unknownEnumValue: NoteStatus.UNACTIVE) required NoteStatus status,
    @JsonKey(fromJson: DateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? updatedAt,
    @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? schedule,
    required List<String> tag,
  }) = _NoteModel;
  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}