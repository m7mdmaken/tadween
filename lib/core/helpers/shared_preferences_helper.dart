import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A comprehensive helper class for managing both regular and secure cached data
///
/// This class provides a unified interface for storing and retrieving various
/// data types using both SharedPreferences (for non-sensitive data) and
/// FlutterSecureStorage (for sensitive data like tokens and credentials).
class SharedPrefsHelper {
  // Private constructor to prevent instantiation
  SharedPrefsHelper._();

  static SharedPreferences? _prefs;
  static bool _isInitialized = false;

  /// Secure storage instance with platform-specific configurations
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: 'secure_cache_prefs',
      preferencesKeyPrefix: 'cache_',
    ),
    iOptions: IOSOptions(
      groupId: 'secure_cache_group',
      accountName: 'secure_cache_account',
      synchronizable: true,
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    lOptions: LinuxOptions(),
    wOptions: WindowsOptions(),
    mOptions: MacOsOptions(
      groupId: 'secure_cache_group',
      accountName: 'secure_cache_account',
      synchronizable: true,
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  /// Initialize both SharedPreferences and SecureStorage
  ///
  /// This method must be called before using any other methods in this class.
  /// Typically called in main() function during app initialization.
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      // Test secure storage availability
      await _secureStorage.read(key: '_test_key');

      _isInitialized = true;
      log('SharedPreferencesHelper: Successfully initialized');
    } catch (e) {
      throw Exception('Failed to initialize SharedPreferencesHelper: $e');
    }
  }

  /// Check if the helper is initialized
  static bool get isInitialized => _isInitialized;

  // ==================== REGULAR SHARED PREFERENCES ====================

  /// Save data to regular SharedPreferences with type validation
  ///
  /// Supports String, int, bool, double, and List<-String-> types.
  /// Returns true if the operation was successful.
  /// Use this for non-sensitive data like user preferences, app settings, etc.
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    _ensureInitialized();

    try {
      bool result;
      switch (value.runtimeType) {
        case const (String):
          result = await _prefs!.setString(key, value as String);
          break;
        case const (int):
          result = await _prefs!.setInt(key, value as int);
          break;
        case const (bool):
          result = await _prefs!.setBool(key, value as bool);
          break;
        case const (double):
          result = await _prefs!.setDouble(key, value as double);
          break;
        case const (List<String>):
          result = await _prefs!.setStringList(key, value as List<String>);
          break;
        default:
          throw ArgumentError(
            'Unsupported value type: ${value.runtimeType}. '
            'Supported types: String, int, bool, double, List<String>.',
          );
      }

      if (result) {
        debugPrint('SharedPreferencesHelper: Data saved with key: $key');
      }
      return result;
    } catch (e) {
      debugPrint(
        'SharedPreferencesHelper: Failed to save data for key "$key": $e',
      );
      throw Exception('Failed to save data for key "$key": $e');
    }
  }

  /// Get data from regular SharedPreferences
  ///
  /// Returns the value associated with the key, or null if not found.
  static dynamic getData({required String key}) {
    _ensureInitialized();
    return _prefs!.get(key);
  }

  /// Get string value from SharedPreferences
  static String? getString({required String key}) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }

  /// Get integer value from SharedPreferences
  static int? getInt({required String key}) {
    _ensureInitialized();
    return _prefs!.getInt(key);
  }

  /// Get boolean value from SharedPreferences
  static bool? getBool({required String key}) {
    _ensureInitialized();
    return _prefs!.getBool(key);
  }

  /// Get double value from SharedPreferences
  static double? getDouble({required String key}) {
    _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  /// Get string list value from SharedPreferences
  static List<String>? getStringList({required String key}) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  /// Check if a key exists in SharedPreferences
  static bool containsKey({required String key}) {
    _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  /// Get all keys from SharedPreferences
  static Set<String> getAllKeys() {
    _ensureInitialized();
    return _prefs!.getKeys();
  }

  /// Remove a specific key from SharedPreferences
  static Future<bool> removeData({required String key}) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.remove(key);
      if (result) {
        debugPrint('SharedPreferencesHelper: Data removed with key: $key');
      }
      return result;
    } catch (e) {
      debugPrint(
        'SharedPreferencesHelper: Failed to remove data for key "$key": $e',
      );
      throw Exception('Failed to remove data for key "$key": $e');
    }
  }

  /// Clear all data from SharedPreferences
  static Future<bool> clearAllData() async {
    _ensureInitialized();
    try {
      final result = await _prefs!.clear();
      if (result) {
        debugPrint(
          'SharedPreferencesHelper: All data cleared from SharedPreferences',
        );
      }
      return result;
    } catch (e) {
      debugPrint(
        'SharedPreferencesHelper: Failed to clear SharedPreferences: $e',
      );
      throw Exception('Failed to clear SharedPreferences: $e');
    }
  }

  /// Reload preferences from disk
  static Future<void> reload() async {
    _ensureInitialized();
    try {
      await _prefs!.reload();
      debugPrint('SharedPreferencesHelper: Preferences reloaded from disk');
    } catch (e) {
      throw Exception('Failed to reload preferences: $e');
    }
  }

  // ==================== SECURE STORAGE ====================

  /// Save sensitive data to secure storage with type preservation
  ///
  /// Supports String, int, bool, double, and List<-String-> types.
  /// All data is encrypted before storage.
  /// Use this for sensitive data like tokens, passwords, API keys, etc.
  static Future<void> saveSecureData({
    required String key,
    required dynamic value,
  }) async {
    _ensureInitialized();

    try {
      String jsonValue;

      if (value is String) {
        jsonValue = json.encode({'value': value, 'type': 'String'});
      } else if (value is int) {
        jsonValue = json.encode({'value': value, 'type': 'int'});
      } else if (value is bool) {
        jsonValue = json.encode({'value': value, 'type': 'bool'});
      } else if (value is double) {
        jsonValue = json.encode({'value': value, 'type': 'double'});
      } else if (value is List<String>) {
        jsonValue = json.encode({'value': value, 'type': 'List<String>'});
      } else {
        throw ArgumentError(
          'Unsupported value type: ${value.runtimeType}. '
          'Supported types: String, int, bool, double, List<String>',
        );
      }

      await _secureStorage.write(key: key, value: jsonValue);
      debugPrint('SharedPreferencesHelper: Secure data saved with key: $key');
    } catch (e) {
      debugPrint(
        'SharedPreferencesHelper: Failed to save secure data for key "$key": $e',
      );
      throw Exception('Failed to save secure data for key "$key": $e');
    }
  }

  /// Get data from secure storage
  ///
  /// Returns the value in its original type, or null if not found.
  static Future<dynamic> getSecureData({required String key}) async {
    _ensureInitialized();

    try {
      final jsonValue = await _secureStorage.read(key: key);
      if (jsonValue == null) return null;

      final Map<String, dynamic> data = json.decode(jsonValue);
      final String type = data['type'];
      final dynamic value = data['value'];

      switch (type) {
        case 'String':
          return value as String;
        case 'int':
          return value as int;
        case 'bool':
          return value as bool;
        case 'double':
          return value as double;
        case 'List<String>':
          return List<String>.from(value);
        default:
          return value;
      }
    } catch (e) {
      debugPrint(
        'SharedPreferencesHelper: Failed to get secure data for key "$key": $e',
      );
      throw Exception('Failed to get secure data for key "$key": $e');
    }
  }

  /// Get string value from secure storage
  static Future<String?> getSecureString({required String key}) async {
    final data = await getSecureData(key: key);
    return data is String ? data : null;
  }

  /// Get integer value from secure storage
  static Future<int?> getSecureInt({required String key}) async {
    final data = await getSecureData(key: key);
    return data is int ? data : null;
  }

  /// Get boolean value from secure storage
  static Future<bool?> getSecureBool({required String key}) async {
    final data = await getSecureData(key: key);
    return data is bool ? data : null;
  }

  /// Get double value from secure storage
  static Future<double?> getSecureDouble({required String key}) async {
    final data = await getSecureData(key: key);
    return data is double ? data : null;
  }

  /// Get string list value from secure storage
  static Future<List<String>?> getSecureStringList({
    required String key,
  }) async {
    final data = await getSecureData(key: key);
    return data is List<String> ? data : null;
  }

  /// Check if a key exists in secure storage
  static Future<bool> containsSecureKey({required String key}) async {
    _ensureInitialized();
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Get all keys from secure storage
  static Future<Set<String>> getAllSecureKeys() async {
    _ensureInitialized();
    try {
      final allData = await _secureStorage.readAll();
      return allData.keys.toSet();
    } catch (e) {
      throw Exception('Failed to get all secure keys: $e');
    }
  }

  /// Remove a specific key from secure storage
  static Future<void> removeSecureData({required String key}) async {
    _ensureInitialized();
    try {
      await _secureStorage.delete(key: key);
      debugPrint('SharedPreferencesHelper: Secure data removed with key: $key');
    } catch (e) {
      debugPrint(
        'SharedPreferencesHelper: Failed to remove secure data for key "$key": $e',
      );
      throw Exception('Failed to remove secure data for key "$key": $e');
    }
  }

  /// Clear all secure storage data
  static Future<void> clearAllSecureData() async {
    _ensureInitialized();
    try {
      await _secureStorage.deleteAll();
      debugPrint('SharedPreferencesHelper: All secure data cleared');
    } catch (e) {
      debugPrint('SharedPreferencesHelper: Failed to clear secure storage: $e');
      throw Exception('Failed to clear secure storage: $e');
    }
  }

  // ==================== CONVENIENCE METHODS ====================

  /// Save authentication token securely
  static Future<void> saveAuthToken({
    required String token,
    String key = 'auth_token',
  }) async {
    await saveSecureData(key: key, value: token);
  }

  /// Get authentication token
  static Future<String?> getAuthToken({String key = 'auth_token'}) async {
    return await getSecureString(key: key);
  }

  /// Remove authentication token
  static Future<void> removeAuthToken({String key = 'auth_token'}) async {
    await removeSecureData(key: key);
  }

  /// Save user credentials securely
  static Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    await saveSecureData(key: 'username', value: username);
    await saveSecureData(key: 'password', value: password);
  }

  /// Get user credentials
  static Future<Map<String, String>?> getCredentials() async {
    final username = await getSecureString(key: 'username');
    final password = await getSecureString(key: 'password');

    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  /// Remove user credentials
  static Future<void> removeCredentials() async {
    await removeSecureData(key: 'username');
    await removeSecureData(key: 'password');
  }

  /// Save user session data
  static Future<void> saveUserSession({
    required String userId,
    required String sessionToken,
    required bool rememberMe,
  }) async {
    await saveSecureData(key: 'user_id', value: userId);
    await saveSecureData(key: 'session_token', value: sessionToken);
    await saveData(key: 'remember_me', value: rememberMe);
  }

  /// Get user session data
  static Future<Map<String, dynamic>?> getUserSession() async {
    final userId = await getSecureString(key: 'user_id');
    final sessionToken = await getSecureString(key: 'session_token');
    final rememberMe = getBool(key: 'remember_me');

    if (userId != null && sessionToken != null) {
      return {
        'userId': userId,
        'sessionToken': sessionToken,
        'rememberMe': rememberMe ?? false,
      };
    }
    return null;
  }

  /// Clear user session
  static Future<void> clearUserSession() async {
    await removeSecureData(key: 'user_id');
    await removeSecureData(key: 'session_token');
    await removeData(key: 'remember_me');
  }

  /// Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final sessionToken = await getSecureString(key: 'session_token');
    return sessionToken != null && sessionToken.isNotEmpty;
  }

  /// Save app theme preference
  static Future<bool> saveThemeMode(String themeMode) async {
    return await saveData(key: 'theme_mode', value: themeMode);
  }

  /// Get app theme preference
  static String getThemeMode() {
    return getString(key: 'theme_mode') ?? 'system';
  }

  /// Save app language preference
  static Future<bool> saveLanguage(String languageCode) async {
    return await saveData(key: 'language_code', value: languageCode);
  }

  /// Get app language preference
  static String getLanguage() {
    return getString(key: 'language_code') ?? 'en';
  }

  /// Save first launch flag
  static Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await saveData(key: 'is_first_launch', value: isFirstLaunch);
  }

  /// Check if this is the first app launch
  static bool isFirstLaunch() {
    return getBool(key: 'is_first_launch') ?? true;
  }

  // ==================== PRIVATE METHODS ====================

  /// Ensure the helper is initialized before use
  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'SharedPreferencesHelper is not initialized. Call SharedPreferencesHelper.init() first.',
      );
    }
  }
}
