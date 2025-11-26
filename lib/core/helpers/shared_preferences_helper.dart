import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';






class SharedPrefsHelper {
  
  SharedPrefsHelper._();

  static SharedPreferences? _prefs;
  static bool _isInitialized = false;

  
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

  
  
  
  
  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      
      await _secureStorage.read(key: '_test_key');

      _isInitialized = true;
      log('SharedPreferencesHelper: Successfully initialized');
    } catch (e) {
      throw Exception('Failed to initialize SharedPreferencesHelper: $e');
    }
  }

  
  static bool get isInitialized => _isInitialized;

  

  
  
  
  
  
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

  
  
  
  static dynamic getData({required String key}) {
    _ensureInitialized();
    return _prefs!.get(key);
  }

  
  static String? getString({required String key}) {
    _ensureInitialized();
    return _prefs!.getString(key);
  }

  
  static int? getInt({required String key}) {
    _ensureInitialized();
    return _prefs!.getInt(key);
  }

  
  static bool? getBool({required String key}) {
    _ensureInitialized();
    return _prefs!.getBool(key);
  }

  
  static double? getDouble({required String key}) {
    _ensureInitialized();
    return _prefs!.getDouble(key);
  }

  
  static List<String>? getStringList({required String key}) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  
  static bool containsKey({required String key}) {
    _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  
  static Set<String> getAllKeys() {
    _ensureInitialized();
    return _prefs!.getKeys();
  }

  
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

  
  static Future<void> reload() async {
    _ensureInitialized();
    try {
      await _prefs!.reload();
      debugPrint('SharedPreferencesHelper: Preferences reloaded from disk');
    } catch (e) {
      throw Exception('Failed to reload preferences: $e');
    }
  }

  

  
  
  
  
  
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

  
  static Future<String?> getSecureString({required String key}) async {
    final data = await getSecureData(key: key);
    return data is String ? data : null;
  }

  
  static Future<int?> getSecureInt({required String key}) async {
    final data = await getSecureData(key: key);
    return data is int ? data : null;
  }

  
  static Future<bool?> getSecureBool({required String key}) async {
    final data = await getSecureData(key: key);
    return data is bool ? data : null;
  }

  
  static Future<double?> getSecureDouble({required String key}) async {
    final data = await getSecureData(key: key);
    return data is double ? data : null;
  }

  
  static Future<List<String>?> getSecureStringList({
    required String key,
  }) async {
    final data = await getSecureData(key: key);
    return data is List<String> ? data : null;
  }

  
  static Future<bool> containsSecureKey({required String key}) async {
    _ensureInitialized();
    try {
      final value = await _secureStorage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  
  static Future<Set<String>> getAllSecureKeys() async {
    _ensureInitialized();
    try {
      final allData = await _secureStorage.readAll();
      return allData.keys.toSet();
    } catch (e) {
      throw Exception('Failed to get all secure keys: $e');
    }
  }

  
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

  

  
  static Future<void> saveAuthToken({
    required String token,
    String key = 'auth_token',
  }) async {
    await saveSecureData(key: key, value: token);
  }

  
  static Future<String?> getAuthToken({String key = 'auth_token'}) async {
    return await getSecureString(key: key);
  }

  
  static Future<void> removeAuthToken({String key = 'auth_token'}) async {
    await removeSecureData(key: key);
  }

  
  static Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    await saveSecureData(key: 'username', value: username);
    await saveSecureData(key: 'password', value: password);
  }

  
  static Future<Map<String, String>?> getCredentials() async {
    final username = await getSecureString(key: 'username');
    final password = await getSecureString(key: 'password');

    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  
  static Future<void> removeCredentials() async {
    await removeSecureData(key: 'username');
    await removeSecureData(key: 'password');
  }

  
  static Future<void> saveUserSession({
    required String userId,
    required String sessionToken,
    required bool rememberMe,
  }) async {
    await saveSecureData(key: 'user_id', value: userId);
    await saveSecureData(key: 'session_token', value: sessionToken);
    await saveData(key: 'remember_me', value: rememberMe);
  }

  
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

  
  static Future<void> clearUserSession() async {
    await removeSecureData(key: 'user_id');
    await removeSecureData(key: 'session_token');
    await removeData(key: 'remember_me');
  }

  
  static Future<bool> isUserLoggedIn() async {
    final sessionToken = await getSecureString(key: 'session_token');
    return sessionToken != null && sessionToken.isNotEmpty;
  }

  
  static Future<bool> saveThemeMode(String themeMode) async {
    return await saveData(key: 'theme_mode', value: themeMode);
  }

  
  static String getThemeMode() {
    return getString(key: 'theme_mode') ?? 'system';
  }

  
  static Future<bool> saveLanguage(String languageCode) async {
    return await saveData(key: 'language_code', value: languageCode);
  }

  
  static String getLanguage() {
    return getString(key: 'language_code') ?? 'en';
  }

  
  static Future<bool> setFirstLaunch(bool isFirstLaunch) async {
    return await saveData(key: 'is_first_launch', value: isFirstLaunch);
  }

  
  static bool isFirstLaunch() {
    return getBool(key: 'is_first_launch') ?? true;
  }

  

  
  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'SharedPreferencesHelper is not initialized. Call SharedPreferencesHelper.init() first.',
      );
    }
  }
}
