import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const String id = 'settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = GetStorage();

  TimeOfDay morningAzkarTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay eveningAzkarTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay morningRecitationTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay eveningRecitationTime = const TimeOfDay(hour: 20, minute: 0);
  int weeklyGoal = 40;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      morningAzkarTime =
          _getTimeFromStorage('morningAzkarTime') ?? morningAzkarTime;
      eveningAzkarTime =
          _getTimeFromStorage('eveningAzkarTime') ?? eveningAzkarTime;
      morningRecitationTime =
          _getTimeFromStorage('morningRecitationTime') ?? morningRecitationTime;
      eveningRecitationTime =
          _getTimeFromStorage('eveningRecitationTime') ?? eveningRecitationTime;
      weeklyGoal = _storage.read('weeklyGoal') ?? weeklyGoal;
    });
  }

  TimeOfDay? _getTimeFromStorage(String key) {
    final stored = _storage.read(key);
    if (stored == null) return null;
    final parts = (stored as String).split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _pickTime(String key, TimeOfDay currentTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null) {
      setState(() {
        switch (key) {
          case 'morningAzkarTime':
            morningAzkarTime = picked;
            break;
          case 'eveningAzkarTime':
            eveningAzkarTime = picked;
            break;
          case 'morningRecitationTime':
            morningRecitationTime = picked;
            break;
          case 'eveningRecitationTime':
            eveningRecitationTime = picked;
            break;
        }
      });
    }
  }

  void _saveSettings() async {
    await _storage.write(
      'morningAzkarTime',
      '${morningAzkarTime.hour}:${morningAzkarTime.minute}',
    );
    await _storage.write(
      'eveningAzkarTime',
      '${eveningAzkarTime.hour}:${eveningAzkarTime.minute}',
    );
    await _storage.write(
      'morningRecitationTime',
      '${morningRecitationTime.hour}:${morningRecitationTime.minute}',
    );
    await _storage.write(
      'eveningRecitationTime',
      '${eveningRecitationTime.hour}:${eveningRecitationTime.minute}',
    );
    await _storage.write('weeklyGoal', weeklyGoal);

    // هنا لازم تعيد جدولة الإشعارات بالوقت الجديد
    // مثلاً تستدعي دالة في NotificationService تقوم بإلغاء الجداول القديمة وجدولة الجديدة
    // انتبه أن تضيف دالة عامة لإعادة الجدولة في NotificationService (مثل reloadScheduledNotifications)

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTimePickerTile(
              'وقت أذكار الصباح',
              morningAzkarTime,
              () => _pickTime('morningAzkarTime', morningAzkarTime),
            ),
            _buildTimePickerTile(
              'وقت أذكار المساء',
              eveningAzkarTime,
              () => _pickTime('eveningAzkarTime', eveningAzkarTime),
            ),
            _buildTimePickerTile(
              'وقت الورد اليومي صباحاً',
              morningRecitationTime,
              () => _pickTime('morningRecitationTime', morningRecitationTime),
            ),
            _buildTimePickerTile(
              'وقت الورد اليومي مساءً',
              eveningRecitationTime,
              () => _pickTime('eveningRecitationTime', eveningRecitationTime),
            ),
            const SizedBox(height: 20),
            Text(
              'الهدف الأسبوعي',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: weeklyGoal.toDouble(),
              min: 10,
              max: 100,
              divisions: 18,
              label: '$weeklyGoal صفحة',
              onChanged: (double value) {
                setState(() {
                  weeklyGoal = value.round();
                });
              },
            ),
            Center(child: Text('$weeklyGoal صفحة')),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _saveSettings, child: const Text('حفظ')),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerTile(
    String title,
    TimeOfDay time,
    VoidCallback onTap,
  ) {
    final formattedTime = time.format(context);
    return ListTile(
      title: Text(title),
      trailing: Text(formattedTime),
      onTap: onTap,
    );
  }
}
