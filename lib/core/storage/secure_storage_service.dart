import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  Future<void> saveUserData(String userData) async {
    await _storage.write(key: AppConstants.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  Future<void> deleteUserData() async {
    await _storage.delete(key: AppConstants.userKey);
  }

  // Save all login response data
  Future<void> saveLoginData({
    required String sessionToken,
    required int userId,
    required String userName,
    required int companyId,
    required bool isEmt,
    required bool isDriver,
    required String expiryTime,
    required String mySchedule,
  }) async {
    await Future.wait([
      _storage.write(key: AppConstants.tokenKey, value: sessionToken),
      _storage.write(key: AppConstants.userIdKey, value: userId.toString()),
      _storage.write(key: AppConstants.userNameKey, value: userName),
      _storage.write(
        key: AppConstants.companyIdKey,
        value: companyId.toString(),
      ),
      _storage.write(key: AppConstants.isEmtKey, value: isEmt.toString()),
      _storage.write(key: AppConstants.isDriverKey, value: isDriver.toString()),
      _storage.write(key: AppConstants.expiryTimeKey, value: expiryTime),
      _storage.write(key: AppConstants.myScheduleKey, value: mySchedule),
    ]);
  }

  // Get individual fields
  Future<String?> getUserId() async {
    return await _storage.read(key: AppConstants.userIdKey);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: AppConstants.userNameKey);
  }

  Future<String?> getCompanyId() async {
    return await _storage.read(key: AppConstants.companyIdKey);
  }

  Future<bool> getIsEmt() async {
    final value = await _storage.read(key: AppConstants.isEmtKey);
    return value == 'true';
  }

  Future<bool> getIsDriver() async {
    final value = await _storage.read(key: AppConstants.isDriverKey);
    return value == 'true';
  }

  Future<String?> getExpiryTime() async {
    return await _storage.read(key: AppConstants.expiryTimeKey);
  }

  Future<String?> getMySchedule() async {
    return await _storage.read(key: AppConstants.myScheduleKey);
  }

  // Save schedule list
  Future<void> saveSchedule(String scheduleJson) async {
    await _storage.write(key: AppConstants.myScheduleKey, value: scheduleJson);
  }

  // Get schedule list
  Future<String?> getSchedule() async {
    return await _storage.read(key: AppConstants.myScheduleKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
