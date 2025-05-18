import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:alhadiqa/lists.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class NotificationService {
  static final GetStorage _storage = GetStorage();
  static const String _notificationKey = 'notifications';

  static Future<void> initializeNotifications() async {
    await GetStorage.init();

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    await _setupNotificationChannels();
    await _scheduleNotifications();
  }

  static Future<void> reloadScheduledNotifications() async {
    await _cancelAllScheduled();

    final storage = GetStorage();

    final morningAzkar =
        _parseTime(storage.read('morningAzkarTime')) ??
        TimeOfDay(hour: 4, minute: 30);
    final eveningAzkar =
        _parseTime(storage.read('eveningAzkarTime')) ??
        TimeOfDay(hour: 16, minute: 0);
    final morningRecitation =
        _parseTime(storage.read('morningRecitationTime')) ??
        TimeOfDay(hour: 12, minute: 0);
    final eveningRecitation =
        _parseTime(storage.read('eveningRecitationTime')) ??
        TimeOfDay(hour: 20, minute: 0);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'أذكار الصباح',
        body: 'حان وقت قراءة أذكار الصباح',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': 'azkar', 'time': 'morning'},
      ),
      schedule: NotificationCalendar(
        hour: morningAzkar.hour,
        minute: morningAzkar.minute,
        second: 0,
        repeats: true,
      ),
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'أذكار المساء',
        body: 'حان وقت قراءة أذكار المساء',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': 'azkar', 'time': 'evening'},
      ),
      schedule: NotificationCalendar(
        hour: eveningAzkar.hour,
        minute: eveningAzkar.minute,
        second: 0,
        repeats: true,
      ),
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'basic_channel',
        title: 'الورد اليومي',
        body: 'تذكير بالورد اليومي للقرآن',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: morningRecitation.hour,
        minute: morningRecitation.minute,
        second: 0,
        repeats: true,
      ),
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 4,
        channelKey: 'basic_channel',
        title: 'الورد اليومي',
        body: 'تذكير بالورد اليومي للقرآن',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: eveningRecitation.hour,
        minute: eveningRecitation.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  static TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null) return null;
    try {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return null;
    }
  }

  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    await _storeNotification(
      id: receivedAction.id ?? DateTime.now().millisecondsSinceEpoch,
      title: receivedAction.title ?? 'Notification',
      body: receivedAction.body ?? '',
      payload: receivedAction.payload ?? {},
    );

    if (receivedAction.payload?['type'] == 'azkar') {}
  }

  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    await _storeNotification(
      id: receivedNotification.id ?? DateTime.now().millisecondsSinceEpoch,
      title: receivedNotification.title ?? 'Notification',
      body: receivedNotification.body ?? '',
      payload: receivedNotification.payload ?? {},
    );
  }

  static Future<void> _storeNotification({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final notifications = _storage.read<List>(_notificationKey) ?? [];

      // Check if notification already exists
      if (!notifications.any((n) => n['id'] == id)) {
        notifications.insert(0, {
          'id': id,
          'title': title,
          'body': body,
          'payload': payload,
          'date': DateTime.now().toIso8601String(),
          'read': false,
        });
        await _storage.write(_notificationKey, notifications);
      }
    } catch (e) {
      debugPrint('Error storing notification: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      await GetStorage.init();
      final notifications = _storage.read<List>(_notificationKey) ?? [];
      return notifications.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error getting notifications: $e');
      return [];
    }
  }

  static Future<void> markAllAsRead() async {
    try {
      final notifications = await getNotifications();
      for (var notification in notifications) {
        notification['read'] = true;
      }
      await _storage.write(_notificationKey, notifications);
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    }
  }

  static Future<void> markAsRead(int id) async {
    try {
      final notifications = await getNotifications();
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) {
        notifications[index]['read'] = true;
        await _storage.write(_notificationKey, notifications);
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  static Future<void> _setupNotificationChannels() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic reminders',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF00796B),
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true,
      ),
    ]);
  }

  static Future<void> _scheduleNotifications() async {
    await _cancelAllScheduled();
    await _scheduleMorningAzkar();
    await _scheduleEveningAzkar();
    await _scheduleDailyAsar();
    await _scheduleSaturdyMeeting();
    await _scheduleTuesdayMeeting();
    await _scheduleMorningDailyRecitation();
    await _scheduleEveningDailyRecitation();
  }

  static Future<void> _cancelAllScheduled() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<void> _scheduleMorningAzkar() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'أذكار الصباح',
        body: 'حان وقت قراءة أذكار الصباح',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': 'azkar', 'time': 'morning'},
      ),
      schedule: NotificationCalendar(
        hour: 4,
        minute: 30,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> _scheduleEveningAzkar() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'أذكار المساء',
        body: 'حان وقت قراءة أذكار المساء',
        notificationLayout: NotificationLayout.Default,
        payload: {'type': 'azkar', 'time': 'evening'},
      ),
      schedule: NotificationCalendar(
        hour: 16,
        minute: 0,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> _scheduleMorningDailyRecitation() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'الورد اليومي',
        body: 'تذكير بالورد اليومي للقرآن',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 12,
        minute: 0,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> _scheduleEveningDailyRecitation() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'الورد اليومي',
        body: 'تذكير بالورد اليومي للقرآن',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 20,
        minute: 0,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> _scheduleDailyAsar() async {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 5, 18)).inDays;
    final asarEntry = asar.entries.elementAt(dayOfYear % asar.length);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: 'basic_channel',
        title: 'آثار يومية',
        body: '${asarEntry.key}\n${asarEntry.value}',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        hour: 13,
        minute: 30,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> _scheduleSaturdyMeeting() async {
    final storage = GetStorage();
    final time =
        _parseTime(storage.read('saturdayMeetingTime')) ??
        TimeOfDay(hour: 19, minute: 30);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 4,
        channelKey: 'basic_channel',
        title: 'درس مع أستاذ أبو عبيدة',
        body: 'تذكير بحضور الدرس',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        weekday: DateTime.saturday,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> _scheduleTuesdayMeeting() async {
    final storage = GetStorage();
    final time =
        _parseTime(storage.read('tuesdayMeetingTime')) ??
        TimeOfDay(hour: 21, minute: 0);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 5,
        channelKey: 'basic_channel',
        title: 'درس مع أستاذ عبدالرحمن الخن',
        body: 'تذكير بحضور الدرس',
        notificationLayout: NotificationLayout.BigText,
      ),
      schedule: NotificationCalendar(
        weekday: DateTime.tuesday,
        hour: time.hour,
        minute: time.minute,
        second: 0,
        repeats: true,
      ),
    );
  }

  static Future<void> deleteNotification(int id) async {
    try {
      final notifications = await getNotifications();
      notifications.removeWhere((n) => n['id'] == id);
      await _storage.write(_notificationKey, notifications);
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  static Future<int> getUnreadCount() async {
    try {
      final notifications = await getNotifications();
      return notifications.where((n) => !n['read']).length;
    } catch (e) {
      debugPrint('Error getting unread count: $e');
      return 0;
    }
  }
}
