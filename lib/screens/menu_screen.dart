import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      appBar: AppBar(
        title: Center(child: Text('القائمة', style: kHeading1TextDark)),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: kDarkPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kLightPrimaryColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.id);
                      },
                      color: kDarkPrimaryColor,
                      icon: Icon(Icons.home),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, HomeScreen.id);
                  },
                  child: Text('الرئيسية', style: kHeading2Text),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kLightPrimaryColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, DailyRecitationScreen.id);
                      },
                      color: kDarkPrimaryColor,
                      icon: Icon(Icons.group),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DailyRecitationScreen.id);
                  },
                  child: Text('التسميع اليومي', style: kHeading2Text),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kLightPrimaryColor,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, IjazahRecitationScreen.id);
                      },
                      color: kDarkPrimaryColor,
                      icon: Icon(Icons.person),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, IjazahRecitationScreen.id);
                  },
                  child: Text('تسميع الاجازة', style: kHeading2Text),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kLightPrimaryColor,
                    child: IconButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, HomeScreen.id);
                      },
                      color: kDarkPrimaryColor,
                      icon: Icon(Icons.dark_mode),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //Navigator.pushNamed(context, HomeScreen.id);
                  },
                  child: Text('رمضان', style: kHeading2Text),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kLightPrimaryColor,
                    child: IconButton(
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
                      color: kDarkPrimaryColor,
                      icon: Icon(Icons.logout),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
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
                  child: Text('تسجيل خروج', style: kHeading2Text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
