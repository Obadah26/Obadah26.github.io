import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/widgets/menu_buttons.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, this.auth, this.userName});
  static String id = 'menu_screen';
  final FirebaseAuth? auth;
  final String? userName;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.notifications_outlined, size: 30),
                Icon(Icons.menu, size: 50),
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 70),
                Center(
                  child: Text(
                    'القائمة',
                    style: GoogleFonts.elMessiri(textStyle: kHeading1Text),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuButtons(
                      icon: Icons.home,
                      text: 'الرئيسية',
                      onPressed: () {
                        Navigator.popAndPushNamed(context, HomeScreen.id);
                      },
                    ),
                    SizedBox(width: 30),
                    MenuButtons(
                      icon: Icons.group,
                      text: 'التسميع اليومي',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DailyRecitationScreen(
                                  userName: widget.userName,
                                ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 30),
                    MenuButtons(
                      icon: Icons.leaderboard,
                      text: 'نتائج التسميع',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RecitationLeaderboardScreen(
                                  userName: widget.userName,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuButtons(
                      icon: Icons.person,
                      text: 'الاجازة',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => IjazahRecitationScreen(
                                  userName: widget.userName,
                                ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 30),
                    MenuButtons(
                      icon: Icons.leaderboard,
                      text: 'نتائج الاجازة',
                      onPressed: () {
                        Navigator.popAndPushNamed(
                          context,
                          IjazahLeaderboardScreen.id,
                        );
                      },
                    ),
                    SizedBox(width: 30),
                    MenuButtons(
                      icon: Icons.dark_mode,
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
                  ],
                ),
                SizedBox(height: 50),
                MenuButtons(
                  icon: Icons.logout,
                  text: 'تسجيل خروج',
                  onPressed: () async {
                    final box = GetStorage();
                    await box.remove('rememberMe');
                    await box.remove('email');

                    if (widget.auth != null) {
                      await widget.auth!.signOut();
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
        ],
      ),
    );
  }
}
