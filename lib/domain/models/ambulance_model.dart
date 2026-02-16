import 'package:json_annotation/json_annotation.dart';

part 'ambulance_model.g.dart';

enum AmbulanceType {
  @JsonValue('basic')
  basic,
  @JsonValue('advanced')
  advanced,
  @JsonValue('critical')
  critical,
}

enum AmbulanceStatus {
  @JsonValue('available')
  available,
  @JsonValue('assigned')
  assigned,
  @JsonValue('on_mission')
  onMission,
  @JsonValue('maintenance')
  maintenance,
}

@JsonSerializable()
class AmbulanceModel {
  final String id;
  final String vehicleNumber;
  final AmbulanceType type;
  final AmbulanceStatus status;
  final String? driverName;
  final String? driverPhone;

  AmbulanceModel({
    required this.id,
    required this.vehicleNumber,
    required this.type,
    required this.status,
    this.driverName,
    this.driverPhone,
  });

  factory AmbulanceModel.fromJson(Map<String, dynamic> json) =>
      _$AmbulanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmbulanceModelToJson(this);

  String get typeDisplayName {
    switch (type) {
      case AmbulanceType.basic:
        return 'Basic Life Support';
      case AmbulanceType.advanced:
        return 'Advanced Life Support';
      case AmbulanceType.critical:
        return 'Critical Care';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case AmbulanceStatus.available:
        return 'Available';
      case AmbulanceStatus.assigned:
        return 'Assigned';
      case AmbulanceStatus.onMission:
        return 'On Mission';
      case AmbulanceStatus.maintenance:
        return 'Maintenance';
    }
  }
}
