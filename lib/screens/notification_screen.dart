import 'package:alhadiqa/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:alhadiqa/notification_service.dart';
import 'package:alhadiqa/screens/azkar_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static String id = 'notification_screen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => isLoading = true);
    try {
      final loadedNotifications = await NotificationService.getNotifications();
      setState(() {
        notifications = loadedNotifications;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ في تحميل الإشعارات: $e')));
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await NotificationService.markAllAsRead();
      await _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في تحديد الإشعارات كمقروءة')),
      );
    }
  }

  Future<void> _markAsRead(int id) async {
    try {
      await NotificationService.markAsRead(id);
      await _loadNotifications();
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return DateFormat('yyyy/MM/dd').format(date);
      } else if (difference.inDays > 0) {
        return 'منذ ${difference.inDays} يوم';
      } else if (difference.inHours > 0) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inMinutes > 0) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else {
        return 'الآن';
      }
    } catch (e) {
      return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'الإشعارات',
          style: GoogleFonts.elMessiri(
            textStyle: kHeading2Text.copyWith(color: kDarkPrimaryColor),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: kDarkPrimaryColor,
              size: 35,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'تحديد الكل',
                style: GoogleFonts.cairo(
                  textStyle: kBodyRegularText.copyWith(
                    color: kDarkPrimaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifications.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا يوجد إشعارات',
                        style: GoogleFonts.cairo(
                          textStyle: kBodyLargeText.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Dismissible(
                      key: Key(notification['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        setState(() {
                          notifications.removeAt(index);
                        });
                        await NotificationService.deleteNotification(
                          notification['id'],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم حذف الإشعار'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () async {
                          if (!notification['read']) {
                            await _markAsRead(notification['id']);
                          }
                          if (notification['payload']?['type'] == 'azkar') {
                            Navigator.pushNamed(context, AzkarScreen.id);
                          }
                        },
                        child: _buildNotificationItem(
                          icon: _getIconForNotification(notification['title']),
                          title: notification['title'],
                          body: notification['body'],
                          time: _formatTime(notification['date']),
                          isUnread: !notification['read'],
                          payload: notification['payload'],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }

  IconData _getIconForNotification(String title) {
    if (title.contains('أذكار الصباح') || title.contains('أذكار المساء')) {
      return FlutterIslamicIcons.tasbihHand;
    } else if (title.contains('آثار يومية')) {
      return Icons.lightbulb_outline;
    } else if (title.contains('درس مع أستاذ أبو عبيدة')) {
      return Icons.video_call_outlined;
    } else if (title.contains('درس مع أستاذ عبدالرحمن الخن')) {
      return Icons.video_call_outlined;
    } else if (title.contains('الورد اليومي')) {
      return FlutterIslamicIcons.quran;
    }
    return Icons.notifications;
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String body,
    required String time,
    bool isUnread = false,
    Map<String, dynamic>? payload,
  }) {
    Color color = isUnread ? kPrimaryColor : Colors.grey;

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUnread ? kLightPrimaryColor : Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight:
                          isUnread ? FontWeight.bold : FontWeight.normal,
                      color: isUnread ? Colors.black87 : Colors.black54,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: isUnread ? kLightPrimaryColor : Colors.grey[600],
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            if (isUnread)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
