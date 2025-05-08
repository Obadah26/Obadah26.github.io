import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/widgets/menu_buttons.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key, this.auth});
  static String id = 'menu_screen';
  final FirebaseAuth? auth;

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
            child: Icon(Icons.menu, color: Colors.white, size: 50),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
      ),
      bottomNavigationBar: BottomBar(selectedIndex: 2),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -35,
            right: -75,
            child: Container(
              width: 250,
              height: 225,
              decoration: BoxDecoration(
                color: Color(0xFF087ea2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text('القائمة', style: kHeading1Text),
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
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            HomeScreen.id,
                            (route) => false,
                          );
                        },
                      ),
                      SizedBox(width: 50),
                      MenuButtons(
                        icon: Icons.group,
                        text: 'التسميع اليومي',
                        size: 12,
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            DailyRecitationScreen.id,
                            (route) => false,
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
                        text: 'تسميع الاجازة',
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            IjazahRecitationScreen.id,
                            (route) => false,
                          );
                        },
                      ),
                      SizedBox(width: 50),
                      MenuButtons(
                        icon: Icons.dark_mode,
                        text: 'رمضان',
                        onPressed: () {
                          //Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
                          showOkAlertDialog(
                            context: context,
                            title: 'رمضان',
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
          ),
        ],
      ),
    );
  }
}
