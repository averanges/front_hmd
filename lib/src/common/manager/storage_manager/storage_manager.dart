import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageManager {
  static const keyAccessToken = 'access_token';
  static const keyUserId = 'user_id';
  static const displayName = 'display_name';
  static const locale = 'locale';

  Future init();

  Future<bool> setValue<T>({required String key, required T value});

  T getValue<T>({required String key, required T defaultValue});

  Future<bool> removeValue(String key);

  String get userId => getValue(key: keyUserId, defaultValue: '');

  String get userName => getValue(key: displayName, defaultValue: '');

  String get localeText => getValue(key: locale, defaultValue: '');

  String get accessToken => getValue(key: keyAccessToken, defaultValue: '');

  Future<void> updateUser(User? user);

  Future<bool> clear();
}

class StorageManagerImpl extends StorageManager {
  late SharedPreferences _preferences;

  @override
  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  T getValue<T>({required String key, required T defaultValue}) {
    T result;

    if (T == String) {
      result = (_preferences.getString(key) ?? defaultValue) as T;
    } else if (T == int) {
      result = (_preferences.getInt(key) ?? defaultValue) as T;
    } else if (T == bool) {
      result = (_preferences.getBool(key) ?? defaultValue) as T;
    } else if (T == double) {
      result = (_preferences.getDouble(key) ?? defaultValue) as T;
    } else {
      throw 'Unsupported Type $T';
    }

    return result;
  }

  @override
  Future<bool> setValue<T>({required String key, required T value}) async {
    bool result;

    if (value is String) {
      result = await _preferences.setString(key, value);
    } else if (value is int) {
      result = await _preferences.setInt(key, value);
    } else if (value is bool) {
      result = await _preferences.setBool(key, value);
    } else if (value is double) {
      result = await _preferences.setDouble(key, value);
    } else {
      throw 'Unsupported Type $value';
    }

    return result;
  }

  @override
  Future<bool> removeValue(String key) async {
    return await _preferences.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _preferences.clear();
  }

  @override
  Future<void> updateUser(User? user) async {
    if (user == null) {
      await removeValue(StorageManager.keyUserId);
      await removeValue(StorageManager.keyAccessToken);
    } else {
      final uid = user.uid;
      final token = await user.getIdToken();
      await setValue(key: StorageManager.keyUserId, value: uid);
      await setValue(key: StorageManager.keyAccessToken, value: token ?? '');
    }
  }
}
