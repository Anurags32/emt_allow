// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  employeeId: json['employeeId'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  phone: json['phone'] as String?,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'employeeId': instance.employeeId,
  'role': _$UserRoleEnumMap[instance.role]!,
  'phone': instance.phone,
  'avatar': instance.avatar,
};

const _$UserRoleEnumMap = {
  UserRole.emt: 'emt',
  UserRole.nurse: 'nurse',
  UserRole.doctor: 'doctor',
};
