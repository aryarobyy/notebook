import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_model.freezed.dart';
part 'note_model.g.dart';

@freezed
sealed class NoteModel with _$NoteModel {
  factory NoteModel({
    required String id,
    required String creatorId,
    required String title,
    required String content,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? schedule,
    required List<String> tags,
  }) = _NoteModel;
  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value == null) return DateTime.now();

  if (value is Map<String, dynamic> &&
      value.containsKey('seconds') &&
      value.containsKey('nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['seconds'] * 1000 + value['nanoseconds'] ~/ 1000000).toInt(),
    );
  }

  if (value is String) {
    return DateTime.parse(value);
  }

  return DateTime.now();
}

DateTime? _dateTimeFromJsonNullable(dynamic value) {
  if (value == null) return null;

  if (value is Map<String, dynamic> &&
      value.containsKey('seconds') &&
      value.containsKey('nanoseconds')) {
    return DateTime.fromMillisecondsSinceEpoch(
      (value['seconds'] * 1000 + value['nanoseconds'] ~/ 1000000).toInt(),
    );
  }

  if (value is String) {
    final str = value.trim();
    if (str.isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(str) ?? DateTime.now();
  }
  return null;
}
