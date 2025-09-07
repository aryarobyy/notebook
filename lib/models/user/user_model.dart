import '../date_time.dart';
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
    @JsonKey(fromJson: DateTimeFromJson) required DateTime createdAt,
    @JsonKey(fromJson: DateTimeFromJsonNullable) DateTime? lastActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}