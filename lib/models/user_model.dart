
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@JsonEnum()
enum Role {
  @JsonValue('ADMIN')
  ADMIN,
  @JsonValue('USER')
  USER,
}

@freezed
sealed class UserModel with _$UserModel {
  factory UserModel({
    required String id,
    required String username,
    String? name,
    String? image,
    @JsonKey(unknownEnumValue: Role.USER) required Role role,
    required String email,
    @JsonKey(fromJson: _dateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJsonNullable) DateTime? lastActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
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
    return DateTime.parse(value);
  }

  return null;
}