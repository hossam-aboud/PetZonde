import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifactions = FlutterLocalNotificationsPlugin();

  static Future init() async {
    tz.initializeTimeZones();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _notifactions.initialize(initializationSettings);
  }

  static Future showScheduledNotifaction(
      {int? id,
      String? title,
      String? body,
      DateTime? dateTime,
      String? repeatTag}) async {
    DateTimeComponents? repeat = getRepeat(repeatTag!);
    _notifactions.zonedSchedule(id!, title, body,
        tz.TZDateTime.from(dateTime!, tz.local), await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: repeat);
  }

  static getRepeat(String tag) {
    switch (tag) {
      case 'Every Day':
        return DateTimeComponents.time;
      case 'Every Week':
        return DateTimeComponents.dayOfWeekAndTime;
    }
    return null;
  }

  static Future cancel(int id) async {
    _notifactions.cancel(id);
  }

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'channelDescription',
        ),
        iOS: IOSNotificationDetails());
  }
}
