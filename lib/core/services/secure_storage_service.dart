import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service class for handling sensitive data storage using FlutterSecureStorage.
/// Used for storing user tokens, IDs, and other encrypted information.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  static const _keyUserToken = 'user_token';
  static const _keyUserId = 'user_id';

  /// Saves the user's authentication token and ID securely.
  /// [token] The JWT or session token.
  /// [userId] The unique identifier for the user.
  Future<void> saveUserAuth(String token, String userId) async {
    await _storage.write(key: _keyUserToken, value: token);
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Retrieves the stored user token.
  Future<String?> getUserToken() async {
    return await _storage.read(key: _keyUserToken);
  }

  /// Retrieves the stored user ID.
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Deletes all stored authentication data (Logout).
  Future<void> logout() async {
    await _storage.delete(key: _keyUserToken);
    await _storage.delete(key: _keyUserId);
  }
}
