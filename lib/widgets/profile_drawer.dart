import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:alhadiqa/screens/azkar_screen.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key, required this.userName, required this.auth});
  final String userName;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.elMessiri(
                        textStyle: kBodyLargeText.copyWith(
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('images/example1.png'),
                      //backgroundImage: AssetImage('images/$userName.png'),
                    ),
                  ],
                ),
              ),
            ),
            DrawerButtons(
              icon: FlutterIslamicIcons.solidMuslim2,
              text: 'التسميع اليومي',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DailyRecitationScreen(userName: userName),
                  ),
                );
              },
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
            DrawerButtons(
              icon: FlutterIslamicIcons.solidQuran2,
              text: 'الاجازة',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => IjazahRecitationScreen(userName: userName),
                  ),
                );
              },
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
              icon: FlutterIslamicIcons.solidTasbihHand,
              text: 'الأذكار',
              onPressed: () {
                Navigator.pushNamed(context, AzkarScreen.id);
              },
            ),
            SizedBox(height: 50),
            Divider(color: kPrimaryColor, indent: 20, endIndent: 20),
            DrawerButtons(
              text: 'الإعدادات',
              icon: Icons.settings,
              onPressed: () {
                //Navigator to settings;
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
                  print("Auth instance is null");
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: GoogleFonts.cairo(
              textStyle: kBodySmallText.copyWith(color: kLightPrimaryColor),
            ),
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: kPrimaryColor,
          iconSize: 30,
        ),
      ],
    );
  }
}
