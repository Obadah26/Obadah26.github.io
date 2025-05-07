import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:alhadiqa/widgets/background_color.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  static String id = 'menu_screen';

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
        backgroundColor: Color(0xFF0288D1),
        toolbarHeight: 50,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Color(0xFF03A9F4),
      body: Stack(
        children: [
          BackgroundColor(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFFFEB3B),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, HomeScreen.id);
                          },
                          color: Color(0xFFFFFFFF),
                          icon: Icon(Icons.home),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, HomeScreen.id);
                      },
                      child: Text('الرئيسية', style: kHeading2TextDark),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFFFEB3B),
                        child: IconButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, HomeScreen.id);
                          },
                          color: Color(0xFFFFFFFF),
                          icon: Icon(Icons.menu_book),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, DailyRecitationScreen.id);
                      },
                      child: Text('التسميع اليومي', style: kHeading2TextDark),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFFFEB3B),
                        child: IconButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, HomeScreen.id);
                          },
                          color: Color(0xFFFFFFFF),
                          icon: Icon(Icons.menu_book),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(context, HomeScreen.id);
                      },
                      child: Text('تسميع الاجازة', style: kHeading2TextDark),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFFFEB3B),
                        child: IconButton(
                          onPressed: () {
                            //Navigator.pushNamed(context, HomeScreen.id);
                          },
                          color: Color(0xFFFFFFFF),
                          icon: Icon(Icons.menu_book),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, HomeScreen.id);
                      },
                      child: Text('رمضان', style: kHeading2TextDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
