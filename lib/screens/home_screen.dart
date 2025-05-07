import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:alhadiqa/widgets/background_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('الحديقة', style: kHeading1TextDark)),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF0288D1),
        toolbarHeight: 50,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Color(0xFF03A9F4),
      body: Stack(
        children: [
          BackgroundColor(begin: Alignment.topLeft, end: Alignment.centerRight),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      // أفضل 5 المسميعين خلال الشهر
                      height: 225,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      // التسميع اليومي
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 225,
                      width: 400,
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      // التسميع منذ انشاء التطبيق
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 225,
                      width: 400,
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
