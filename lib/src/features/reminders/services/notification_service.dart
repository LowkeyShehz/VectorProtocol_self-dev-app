import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as fln;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final fln.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      fln.FlutterLocalNotificationsPlugin();

  final Map<int, Timer> _linuxTimers = {};

  Future<void> init() async {
    tz.initializeTimeZones();

    // Android initialization settings
    const fln.AndroidInitializationSettings initializationSettingsAndroid =
        fln.AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    final fln.DarwinInitializationSettings initializationSettingsDarwin =
        fln.DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final fln.InitializationSettings initializationSettings =
        fln.InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: fln.LinuxInitializationSettings(
        defaultActionName: 'Open notification',
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (fln.NotificationResponse response) async {
        // Handle notification tap
      },
    );
    print('NotificationService: init() completed.');
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              fln.AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              fln.AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              fln.IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> scheduleNotification(
      int id, String title, DateTime scheduledTime, String? payload) async {
    if (Platform.isLinux) {
      _linuxTimers[id]?.cancel();
      final delay = scheduledTime.difference(DateTime.now());
      if (delay.isNegative) {
        // If time is past, show immediately or ignore? Show immediately for feedback.
        _showLinuxNotification(id, title, payload);
      } else {
        _linuxTimers[id] = Timer(delay, () {
          _showLinuxNotification(id, title, payload);
          _linuxTimers.remove(id);
        });
      }
      return;
    }

    // Default mobile scheduling
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'REMINDER: INCOMING SIGNAL',
      title,
      tz.TZDateTime.from(scheduledTime, tz.local),
      fln.NotificationDetails(
        android: fln.AndroidNotificationDetails(
          'level_up_reminders',
          'Level Up Reminders',
          channelDescription: 'Main channel for Level Up reminders',
          importance: fln.Importance.max,
          priority: fln.Priority.high,
        ),
      ),
      androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> _showLinuxNotification(
      int id, String title, String? payload) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      'REMINDER: INCOMING SIGNAL',
      title,
      const fln.NotificationDetails(
        linux: fln.LinuxNotificationDetails(
          defaultActionName: 'Open',
        ),
      ),
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    if (Platform.isLinux) {
      _linuxTimers[id]?.cancel();
      _linuxTimers.remove(id);
      // We don't cancel native notification because we just showed it or haven't yet,
      // but if a persistent one was shown we can remove it.
      await flutterLocalNotificationsPlugin.cancel(id);
    } else {
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }
}
