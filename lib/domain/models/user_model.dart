import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum UserRole {
  @JsonValue('emt')
  emt,
  @JsonValue('nurse')
  nurse,
  @JsonValue('doctor')
  doctor,
}

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String employeeId;
  final UserRole role;
  final String? phone;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeId,
    required this.role,
    this.phone,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get roleDisplayName {
    switch (role) {
      case UserRole.emt:
        return 'EMT';
      case UserRole.nurse:
        return 'Nurse';
      case UserRole.doctor:
        return 'Doctor';
    }
  }
}
