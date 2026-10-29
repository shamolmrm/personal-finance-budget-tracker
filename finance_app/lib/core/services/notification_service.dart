import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    const android = AndroidNotificationDetails('default', 'Default', importance: Importance.high);
    const platform = NotificationDetails(android: android);
    await _plugin.show(id, title, body, platform);
  }
}
