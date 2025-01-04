import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:haimdall/src/common/logger/logger.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FCMHandler {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  FCMHandler() {
    _initNotification();

    FirebaseMessaging.onMessage.listen(_showNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    messaging.getInitialMessage().then(_onMessageOpenedApp);
  }

  void _initNotification() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    final result = await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    Log.i(' notification plugin init: $result');

    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      if (value?.didNotificationLaunchApp == true) {
        final response = value?.notificationResponse;
        if (response != null) {
          onDidReceiveNotificationResponse(response);
        }
      }
    });
  }

  void _showNotification(RemoteMessage message) async {
    Log.i('Got a message whilst in the foreground!');
    Log.i('Message data: ${message.data}');
    Log.i('Message notification title: ${message.notification?.title}');
    Log.i('Message notification body: ${message.notification?.body}');

    final data = message.data;

    final title = data['title'];
    final body = data['body'];

    final payloadJson = jsonEncode(data);

    final packageInfo = await PackageInfo.fromPlatform();

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '${packageInfo.packageName}.push',
      '알림',
      channelDescription: '기본 알림 채널입니다.',
      importance: Importance.max,
      priority: Priority.max,
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    var id = message.data['farmland_id'];
    if (id is String) {
      id = int.tryParse(id) ?? 0;
    } else {
      id ??= 0;
    }
    await _flutterLocalNotificationsPlugin.show(
      id,
      title ?? '타이틀',
      body ?? '메시지',
      platformChannelSpecifics,
      payload: payloadJson,
    );

    Log.i('[FCM] Shown Notification');
  }

  void _onMessageOpenedApp(RemoteMessage? message) {
    Log.i('A new onMessageOpenedApp event was published!');
    Log.i('Message data: ${message?.data}');
    Log.i('Message notification title: ${message?.notification?.title}');
    Log.i('Message notification body: ${message?.notification?.body}');

    if (message == null) {
      return;
    }

    final payloadJson = jsonEncode(message.data);

    _onSelectNotification(payloadJson);
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    Log.i('[Push] onDidReceiveLocalNotification');

    _onSelectNotification(payload);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    Log.i('[Push] onSelectNotification $payload');
    _onSelectNotification(payload);
  }

  void _onSelectNotification(String? payload) async {
    if (payload == null || payload.isEmpty) {
      return;
    }
    Map<String, dynamic> data = jsonDecode(payload);

    var farmlandId = data['farmland_id'];
    if (farmlandId is String) {
      farmlandId = int.tryParse(farmlandId);
    }
    if (farmlandId != null) {
      Get.offAllNamed(
        AppRoute.splashPage,
        arguments: {
          'farmlandId': farmlandId,
        },
      );
    }
  }
}
