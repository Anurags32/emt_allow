class AppConstants {
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String companyIdKey = 'company_id';
  static const String isEmtKey = 'is_emt';
  static const String isDriverKey = 'is_driver';
  static const String expiryTimeKey = 'expiry_time';
  static const String myScheduleKey = 'my_schedule';
  static const String pendingLoginKey = 'pending_login';

  // API Base URL
  static const String baseUrl = 'http://192.168.29.106:8018';

  // API Endpoints
  static const String loginEndpoint = '/api/login';
  static const String logoutEndpoint = '/api/logout';
  static const String checkInEndpoint = '/api/check_in';
  static const String checkInOutEndpoint = '/api/check_in_out';
  static const String getScheduleEndpoint = '/api/get_schedule';
  static const String ambulanceEndpoint = '/api/ambulance';
  static const String missionEndpoint = '/api/mission';
  static const String patientEndpoint = '/api/patient';
  static const String medicalNotesEndpoint = '/api/medical-notes';
  static const String handoverEndpoint = '/api/handover';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
