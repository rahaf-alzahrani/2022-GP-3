import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notification {
  static final _notification = FlutterLocalNotificationsPlugin();
  Future<void> initializePlatformSpecifics() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_notf_icon');
    final InitializationSettings settings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notification.initialize(
      settings,
      // onSelect(payload)
    );
  }

  void onSelect(String? payload) {
    print("payload $payload");
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel ID', 'channel name',
            channelDescription: 'channel description',
            playSound: true,
            importance: Importance.max,
            ticker: 'ticker'));
  }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(id, title, body, await _notificationDetails(),
          payload: payload);
}
