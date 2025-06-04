import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:alhadiqa/notification_service.dart';
import 'package:alhadiqa/screens/azkar_screen.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/pending_confirmations_screen.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';
import 'package:alhadiqa/screens/settings_screen.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.userName,
    required this.auth,
    required this.isTeacher,
    required this.loadWeeklyGoal,
  });
  final String userName;
  final FirebaseAuth auth;
  final bool isTeacher;
  final Function loadWeeklyGoal;

  @override
  Widget build(BuildContext context) {
    final words = userName.split(' ');
    if (userName.isEmpty || userName == '...جاري التحميل') {
      return Drawer(child: Center(child: CircularProgressIndicator()));
    }
    return SizedBox(
      width: 250,
      child: Drawer(
        backgroundColor: kBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      userName,
                      style: GoogleFonts.elMessiri(
                        textStyle: kBodyLargeText.copyWith(
                          fontWeight: FontWeight.w500,
                          color: kSecondaryTextLight,
                        ),
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kLightPrimaryColor, width: 1),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Text(
                          isTeacher
                              ? '${words.length > 1 ? words[1][0] : ''} ${words.length > 2 ? words[2][0] : ''}'
                              : '${words.isNotEmpty ? words[0][0] : ''} ${words.length > 1 ? words[1][0] : ''}',
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: -1.5,
                            fontWeight: FontWeight.w500,
                            color: kSecondaryTextLight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isTeacher ? false : true,
              child: DrawerButtons(
                icon: FlutterIslamicIcons.solidQuran2,
                text: 'التسميع اليومي',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              DailyRecitationScreen(userName: userName),
                    ),
                  );
                },
              ),
            ),
            DrawerButtons(
              icon: Icons.bar_chart,
              text: 'نتائج التسميع',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            RecitationLeaderboardScreen(userName: userName),
                  ),
                );
              },
            ),
            Visibility(
              visible: isTeacher ? false : true,
              child: DrawerButtons(
                icon: FlutterIslamicIcons.solidMuslim2,
                text: 'الاجازة',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              IjazahRecitationScreen(userName: userName),
                    ),
                  );
                },
              ),
            ),
            DrawerButtons(
              icon: Icons.bar_chart,
              text: 'نتائج الاجازة',
              onPressed: () {
                Navigator.pushNamed(context, IjazahLeaderboardScreen.id);
              },
            ),
            DrawerButtons(
              icon: FlutterIslamicIcons.solidLantern,
              text: 'رمضان',
              onPressed: () {
                showOkAlertDialog(
                  context: context,
                  title: 'غير فعال',
                  message: 'يتفعل خلال رمضان فقط',
                  okLabel: 'حسناً',
                );
              },
            ),
            DrawerButtons(
              icon: FlutterIslamicIcons.solidMosque,
              text: 'أوقات الصلاة',
              onPressed: () {
                showOkAlertDialog(
                  context: context,
                  title: 'غير متوفر حالياً',
                  message: 'سيتم التفعيل قريباً',
                  okLabel: 'حسناً',
                );
              },
            ),
            DrawerButtons(
              icon: FlutterIslamicIcons.solidTasbihHand,
              text: 'الأذكار',
              onPressed: () {
                Navigator.pushNamed(context, AzkarScreen.id);
              },
            ),
            Visibility(
              visible: isTeacher ? false : true,
              child: DrawerButtons(
                icon: Icons.checklist_rounded,
                text: 'الطلبات',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PendingConfirmationsScreen(userName: userName),
                    ),
                  );
                },
              ),
            ),
            DrawerButtons(
              icon: Icons.photo_library,
              text: 'البوم الصور',
              onPressed: () {
                showOkAlertDialog(
                  context: context,
                  title: 'غير متوفر حالياً',
                  message: 'سيتم التفعيل قريباً',
                  okLabel: 'حسناً',
                );
              },
            ),
            SizedBox(height: 20),
            Divider(color: kLightPrimaryColor, indent: 20, endIndent: 20),
            SizedBox(height: 20),
            DrawerButtons(
              text: 'الإعدادات',
              icon: Icons.settings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SettingsScreen(
                          isTeacher: isTeacher,
                          userName: userName,
                        ),
                  ),
                ).then((_) async {
                  await NotificationService.reloadScheduledNotifications();
                  loadWeeklyGoal();
                });
              },
            ),
            DrawerButtons(
              icon: Icons.logout,
              text: 'تسجيل خروج',
              onPressed: () async {
                final box = GetStorage();
                await box.remove('rememberMe');
                await box.remove('email');

                if (auth != null) {
                  await auth!.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    WelcomeScreen.id,
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger(child: Text('Auth instance is null'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerButtons extends StatelessWidget {
  const DrawerButtons({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: GoogleFonts.cairo(
                textStyle: kBodyRegularText.copyWith(
                  color: kSecondaryTextLight,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: kLightPrimaryColor,
            iconSize: 35,
          ),
        ],
      ),
    );
  }
}
