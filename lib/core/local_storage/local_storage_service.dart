import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgtl_flutter_test/features/features.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  SharedPreferences? _prefs;
  static const _secureStorage = FlutterSecureStorage();

  Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
    } catch (e) {
      throw Exception('Failed to initialize SharedPreferences: $e');
    }
  }

  // String operations
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs?.setString(key, value);
    } catch (e) {
      throw Exception('Failed to save string for key $key: $e');
    }
  }

  String? getString(String key) {
    try {
      return _prefs?.getString(key);
    } catch (e) {
      throw Exception('Failed to get string for key $key: $e');
    }
  }

  // Boolean operations
  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs?.setBool(key, value);
    } catch (e) {
      throw Exception('Failed to save bool for key $key: $e');
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs?.getBool(key);
    } catch (e) {
      throw Exception('Failed to get bool for key $key: $e');
    }
  }

  // Integer operations
  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs?.setInt(key, value);
    } catch (e) {
      throw Exception('Failed to save int for key $key: $e');
    }
  }

  int? getInt(String key) {
    try {
      return _prefs?.getInt(key);
    } catch (e) {
      throw Exception('Failed to get int for key $key: $e');
    }
  }

  // Double operations
  Future<void> saveDouble(String key, double value) async {
    try {
      await _prefs?.setDouble(key, value);
    } catch (e) {
      throw Exception('Failed to save double for key $key: $e');
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs?.getDouble(key);
    } catch (e) {
      throw Exception('Failed to get double for key $key: $e');
    }
  }

  // List operations
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _prefs?.setStringList(key, value);
    } catch (e) {
      throw Exception('Failed to save string list for key $key: $e');
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _prefs?.getStringList(key);
    } catch (e) {
      throw Exception('Failed to get string list for key $key: $e');
    }
  }

  // Map operations
  Future<void> saveMap(String key, Map<String, dynamic> value) async {
    try {
      await _prefs?.setString(key, jsonEncode(value));
    } catch (e) {
      throw Exception('Failed to save map for key $key: $e');
    }
  }

  Map<String, dynamic>? getMap(String key) {
    try {
      final jsonString = _prefs?.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get map for key $key: $e');
    }
  }

  // DateTime operations
  Future<void> saveDateTime(String key, DateTime value) async {
    try {
      await _prefs?.setInt(key, value.millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to save DateTime for key $key: $e');
    }
  }

  DateTime? getDateTime(String key) {
    try {
      final timestamp = _prefs?.getInt(key);
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      throw Exception('Failed to get DateTime for key $key: $e');
    }
  }

  // Utility operations
  Future<void> remove(String key) async {
    try {
      await _prefs?.remove(key);
    } catch (e) {
      throw Exception('Failed to remove key $key: $e');
    }
  }

  Future<void> clear() async {
    try {
      await _prefs?.clear();
    } catch (e) {
      throw Exception('Failed to clear SharedPreferences: $e');
    }
  }

  bool containsKey(String key) {
    try {
      return _prefs?.containsKey(key) ?? false;
    } catch (e) {
      throw Exception('Failed to check if key $key exists: $e');
    }
  }

  Set<String> getKeys() {
    try {
      return _prefs?.getKeys() ?? {};
    } catch (e) {
      throw Exception('Failed to get keys: $e');
    }
  }

  // User-specific operations
  Future<void> saveUser(User user) async {
    try {
      await saveMap('app_user', user.toJson()!);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  User? getUser() {
    try {
      final res = getMap('app_user');
      if (res == null) return null;
      return User.fromJson(res);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> removeUser() async {
    try {
      await remove('app_user');
    } catch (e) {
      throw Exception('Failed to remove user: $e');
    }
  }

  // Auth token operations
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: 'auth_token', value: token);
    } catch (e) {
      throw Exception('Failed to save auth token: $e');
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: 'auth_token');
    } catch (e) {
      throw Exception('Failed to get auth token: $e');
    }
  }

  Future<void> removeAuthToken() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
    } catch (e) {
      throw Exception('Failed to remove auth token: $e');
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    try {
      return getUser() != null;
    } catch (e) {
      return false;
    }
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    try {
      await removeAuthToken();
      await removeUser();
    } catch (e) {
      throw Exception('Failed to clear auth data: $e');
    }
  }
}
