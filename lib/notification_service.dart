import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  Future<void> scheduleMedicationNotification(
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    await notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'medication_channel',
          'Medication Reminders',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('alarm'),
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'alarm.aiff',
        ),
      ),
      // androidAllowWhileIdle: true,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
