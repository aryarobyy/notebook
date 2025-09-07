// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      role: $enumDecode(_$RoleEnumMap, json['role'], unknownValue: Role.USER),
      email: json['email'] as String,
      createdAt: DateTimeFromJson(json['createdAt']),
      lastActive: DateTimeFromJsonNullable(json['lastActive']),
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'image': instance.image,
      'role': _$RoleEnumMap[instance.role]!,
      'email': instance.email,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActive': instance.lastActive?.toIso8601String(),
    };

const _$RoleEnumMap = {
  Role.ADMIN: 'ADMIN',
  Role.USER: 'USER',
};
