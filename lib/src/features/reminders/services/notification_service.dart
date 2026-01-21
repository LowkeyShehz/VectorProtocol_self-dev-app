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

  final StreamController<String?> _onNotificationTap =
      StreamController<String?>.broadcast();
  Stream<String?> get onNotificationTap => _onNotificationTap.stream;

  String? pendingPayload;

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
        if (response.payload != null) {
          pendingPayload = response.payload;
          _onNotificationTap.add(response.payload);
        }
      },
    );

    // Check if app was launched by notification
    final details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse?.payload != null) {
      pendingPayload = details.notificationResponse?.payload;
      _onNotificationTap.add(pendingPayload);
    }

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

  Future<void> scheduleDailyQuotes(List<String> quotes,
      {int hour = 6, int minute = 0}) async {
    // 1. Cancel existing quote notifications
    await cancelDailyQuotes();

    if (quotes.isEmpty) return;

    // 2. Schedule for next 30 days at 6 AM
    // We shuffle quotes to make it random
    final shuffled = List<String>.from(quotes)..shuffle();
    final now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      // Calculate 6 AM for (Now + i days)
      // If today is before 6 AM, day 0 is today. If after, day 0 is tomorrow.
      // Actually simplest is just schedule from Today's 6AM. If it's passed, zonedSchedule might throw or fire immediately depending on settings,
      // or we just find Next Instance of 6 AM and add 'i' days.

      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      scheduledDate = scheduledDate.add(Duration(days: i));

      final quote = shuffled[i % shuffled.length];
      final id = 1000 + i;

      if (Platform.isLinux) {
        // Linux timer limitation: Only viable for current session.
        // We can schedule them, but they die on close.
        // Re-scheduling on startup handles persistence.
        final delay = scheduledDate.difference(now);
        if (!delay.isNegative) {
          _linuxTimers[id] = Timer(delay, () {
            _showLinuxQuote(id, quote);
            _linuxTimers.remove(id);
          });
        }
      } else {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          'DAILY MOTIVATION',
          quote,
          tz.TZDateTime.from(scheduledDate, tz.local),
          fln.NotificationDetails(
            android: fln.AndroidNotificationDetails(
              'level_up_quotes',
              'Daily Motivation',
              channelDescription: 'Daily inspirational quotes',
              importance: fln.Importance.defaultImportance,
              priority: fln.Priority.defaultPriority,
              styleInformation: fln.BigTextStyleInformation(quote),
            ),
          ),
          androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'quote',
        );
      }
    }
    print('Scheduled daily quotes for next 30 days.');
  }

  Future<void> _showLinuxQuote(int id, String quote) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      'DAILY MOTIVATION',
      quote,
      const fln.NotificationDetails(
        linux: fln.LinuxNotificationDetails(
          defaultActionName: 'Read',
        ),
      ),
    );
  }

  Future<void> cancelDailyQuotes() async {
    // Cancel range 1000-1049
    for (int i = 0; i < 50; i++) {
      final id = 1000 + i;
      if (Platform.isLinux) {
        _linuxTimers[id]?.cancel();
        _linuxTimers.remove(id);
      }
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }

  Future<void> cancelAll() async {
    if (Platform.isLinux) {
      for (final timer in _linuxTimers.values) {
        timer.cancel();
      }
      _linuxTimers.clear();
    }
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleCustomNotification({
    required int hour,
    required int minute,
    required String message,
    required String? mediaPath,
    required bool isVideo,
  }) async {
    // ID for custom notification: 2000-2029 (Daily Recurrence)
    await cancelCustomNotification();

    // Schedule for next 30 days
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      scheduledDate = scheduledDate.add(Duration(days: i));

      final id = 2000 + i;
      final payload = mediaPath != null
          ? 'custom_media|${isVideo ? "video" : "image"}|$mediaPath'
          : 'custom_media';

      if (Platform.isLinux) {
        final delay = scheduledDate.difference(now);
        if (!delay.isNegative) {
          _linuxTimers[id] = Timer(delay, () {
            _showLinuxNotification(id, message, payload);
            _linuxTimers.remove(id);
          });
        }
      } else {
        fln.StyleInformation? styleInformation;
        if (mediaPath != null && !isVideo) {
          styleInformation = fln.BigPictureStyleInformation(
            fln.FilePathAndroidBitmap(mediaPath),
            contentTitle: 'DAILY REMINDER',
            summaryText: message,
          );
        }

        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          'DAILY REMINDER',
          message,
          tz.TZDateTime.from(scheduledDate, tz.local),
          fln.NotificationDetails(
            android: fln.AndroidNotificationDetails(
              'level_up_custom',
              'Custom Notifications',
              channelDescription: 'User defined daily notifications',
              importance: fln.Importance.max,
              priority: fln.Priority.max,
              fullScreenIntent: true,
              category: fln.AndroidNotificationCategory.alarm,
              audioAttributesUsage: fln.AudioAttributesUsage.alarm,
              visibility: fln.NotificationVisibility.public,
              playSound: true,
              enableVibration: true,
              styleInformation: styleInformation,
              actions: <fln.AndroidNotificationAction>[
                const fln.AndroidNotificationAction('view', 'VIEW NOW'),
              ],
            ),
          ),
          androidScheduleMode: fln.AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      }
    }
  }

  Future<void> cancelCustomNotification() async {
    for (int i = 0; i < 30; i++) {
      final id = 2000 + i;
      if (Platform.isLinux) {
        _linuxTimers[id]?.cancel();
        _linuxTimers.remove(id);
      }
      await flutterLocalNotificationsPlugin.cancel(id);
    }
  }
}
