import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/notification_service.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/build_time_picker_tile.dart';
import 'package:alhadiqa/widgets/custom_switch.dart';
import 'package:alhadiqa/widgets/green_contatiner.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.isTeacher,
    required this.userName,
  });
  final bool isTeacher;
  final String userName;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = GetStorage();

  TimeOfDay morningAzkarTime = const TimeOfDay(hour: 4, minute: 30);
  TimeOfDay eveningAzkarTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay morningRecitationTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay eveningRecitationTime = const TimeOfDay(hour: 20, minute: 0);
  int weeklyGoal = 40;
  bool isOn = true;

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
      isOn = _storage.read('notifications_enabled_${widget.userName}') ?? true;
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              onSurface: kPrimaryColor,
              surface: Colors.white,
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodColor: kPrimaryColor,
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return kPrimaryColor;
              }),

              dialHandColor: kPrimaryColor,
              dialBackgroundColor: Colors.white,
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return kPrimaryColor;
              }),
              hourMinuteColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return kPrimaryColor;
                }
                return Colors.transparent;
              }),
            ),
          ),
          child: child!,
        );
      },
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

    await NotificationService.reloadScheduledNotifications();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.id,
                (route) => false,
              );
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 30,
              color: kDarkPrimaryColor,
            ),
          ),
        ),
        title: Text(
          'الإعدادات',
          style: GoogleFonts.elMessiri(
            textStyle: kHeading2Text.copyWith(color: kDarkPrimaryColor),
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.settings, size: 30, color: kDarkPrimaryColor),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    'الإشعارات',
                    style: GoogleFonts.elMessiri(
                      color: kPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              GreenContatiner(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomSwitch(
                            value: isOn,
                            onChanged: (bool value) {
                              setState(() {
                                isOn = value;
                              });
                              _storage.write(
                                'notifications_enabled_${widget.userName}',
                                isOn,
                              );
                              if (isOn) {
                                NotificationService.reloadScheduledNotifications();
                              } else {
                                AwesomeNotifications().cancelAllSchedules();
                              }
                            },
                          ),
                          Text(
                            'الإشعارات',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: kPrimaryTextLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: kLightPrimaryColor,
                      endIndent: 20,
                      indent: 20,
                    ),
                    BuildTimePickerTile(
                      title: 'وقت أذكار الصباح',
                      time: morningAzkarTime,
                      onTap:
                          () => _pickTime('morningAzkarTime', morningAzkarTime),
                    ),
                    BuildTimePickerTile(
                      title: 'وقت أذكار المساء',
                      time: eveningAzkarTime,
                      onTap:
                          () => _pickTime('eveningAzkarTime', eveningAzkarTime),
                    ),
                    BuildTimePickerTile(
                      title: 'وقت الورد اليومي صباحاً',
                      time: morningRecitationTime,
                      onTap:
                          () => _pickTime(
                            'morningRecitationTime',
                            morningRecitationTime,
                          ),
                    ),
                    BuildTimePickerTile(
                      title: 'وقت الورد اليومي مساءً',
                      time: eveningRecitationTime,
                      onTap:
                          () => _pickTime(
                            'eveningRecitationTime',
                            eveningRecitationTime,
                          ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.isTeacher ? false : true,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 25, 0),
                    child: Text(
                      'الهدف الأسبوعي',
                      style: GoogleFonts.elMessiri(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isTeacher ? false : true,
                child: GreenContatiner(
                  child: Column(
                    children: [
                      Text(
                        'الهدف الأسبوعي',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: kPrimaryTextLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Slider(
                        value: weeklyGoal.toDouble(),
                        min: 10,
                        max: 100,
                        activeColor: kPrimaryColor,
                        inactiveColor: Colors.grey[400],
                        divisions: 18,
                        label: '$weeklyGoal',
                        onChanged: (double value) {
                          setState(() {
                            weeklyGoal = value.round();
                          });
                        },
                      ),
                      Center(
                        child: Text(
                          '$weeklyGoal صفحة',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: kLightPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              RoundedButton(
                onPressed: _saveSettings,
                buttonText: 'حفظ',
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
