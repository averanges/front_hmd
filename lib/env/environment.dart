import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/build_type.dart';
import 'package:haimdall/src/app.dart';
import 'package:haimdall/src/common/logger/logger.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/repository/auth/auth_repository.dart';
import 'package:haimdall/src/fcm/fcm_handler.dart';
import 'package:intl/date_symbol_data_local.dart';

class Environment {
  static late Environment _instance;

  static Environment get instance => _instance;

  final BuildType _buildType;

  static BuildType get buildType => instance._buildType;

  const Environment._internal(this._buildType);

  factory Environment.newInstance(BuildType buildType) {
    _instance = Environment._internal(buildType);

    return _instance;
  }

  bool get isDebugMode => kReleaseMode == false;

  void run() async {
    Log.d('started App by ${isDebugMode ? 'Debug' : 'Release'} mode');

    changeStatusBarBGColor(Colors.transparent);

    WidgetsFlutterBinding.ensureInitialized();

    final storageManager = Get.put<StorageManager>(StorageManagerImpl());

    await storageManager.init();

    // Firebase Initialize
    await Firebase.initializeApp();

    await initializeDateFormatting();

    FirebaseMessaging.instance.onTokenRefresh.listen((refreshToken) {
      Log.d('[FCM] onTokenRefresh');
      _sendToken(refreshToken);
    });

    FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
      if (user == null) {
        await storageManager.removeValue(StorageManager.keyUserId);
        await storageManager.removeValue(StorageManager.keyAccessToken);
        await storageManager.removeValue(StorageManager.displayName);
        Log.i('User is currently signed out!');
      } else {
        final uid = user.uid;
        final token = await user.getIdToken();
        final displayName = user.displayName ?? '';
        await storageManager.setValue(
            key: StorageManager.keyUserId, value: uid);
        await storageManager.setValue(
            key: StorageManager.keyAccessToken, value: token ?? '');
        await storageManager.setValue(
            key: StorageManager.displayName, value: displayName);
        Log.i('User is signed in!');
      }
    });

    injectRepositories();

    // Crashlytics Initialize
    if (isDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    FCMHandler();

    runApp(const App());
  }

  void _sendToken(String token) async {
    await Get.find<AuthRepository>().updateFcmToken(token);
  }

  void changeStatusBarBGColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
