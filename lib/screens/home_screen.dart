import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';

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
        title: Center(child: Text('الحديقة', style: kHeading1Text)),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: kDarkPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
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
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Container(
                  // التسميع اليومي
                  decoration: BoxDecoration(
                    color: kLightPrimaryColor,
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
                    color: kPrimaryColor,
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
    );
  }
}
