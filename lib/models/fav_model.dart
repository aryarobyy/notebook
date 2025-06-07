import 'package:freezed_annotation/freezed_annotation.dart';

part 'fav_model.freezed.dart';
part 'fav_model.g.dart';

@freezed
sealed class FavModel with _$FavModel {
  factory FavModel({
    required String id,
    required List<String>? noteId,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
  }) = _FavModel;

  factory FavModel.fromJson(Map<String, dynamic> json) =>
      _$FavModelFromJson(json);
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