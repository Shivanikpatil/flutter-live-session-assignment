import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const _keyUserToken = 'user_token';
  static const _keyUserId = 'user_id';

  Future<void> saveUserAuth(String token, String userId) async {
    await _storage.write(key: _keyUserToken, value: token);
    await _storage.write(key: _keyUserId, value: userId);
  }

  Future<String?> getUserToken() async {
    return await _storage.read(key: _keyUserToken);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<void> logout() async {
    await _storage.delete(key: _keyUserToken);
    await _storage.delete(key: _keyUserId);
  }
}
