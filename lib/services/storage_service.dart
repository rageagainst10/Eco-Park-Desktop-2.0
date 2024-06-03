import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'authToken');
  }

  Future<void> saveUserRole(String userRole) async {
    await _storage.write(key: 'userRole', value: userRole);
  }
  Future<String?> getUserRole() async {
    return await _storage.read(key: 'userRole');
  }
  Future<void> deleteUserRole() async {
    await _storage.delete(key: 'userRole');
  }
  Future<void> saveUserEmail(String userEmail) async {
    await _storage.write(key: 'userEmail', value: userEmail);
  }
  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'userEmail');
  }
  Future<void> deleteUserEmail() async {
    await _storage.delete(key: 'userEmail');
  }

}
