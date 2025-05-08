import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('الحديقة', style: kHeading1Text)),
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: kDarkPrimaryColor,
      ),
      bottomNavigationBar: BottomBar(auth: _auth),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'أفضل 5 مسمعين خلال الشهر الماضي',
                          style: kBodyLargeTextDark.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('1. فلان', style: kBodyRegularTextDark),
                        Text('2. فلان', style: kBodyRegularTextDark),
                        Text('3. فلان', style: kBodyRegularTextDark),
                        Text('4. فلان', style: kBodyRegularTextDark),
                        Text('5. فلان', style: kBodyRegularTextDark),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Container(
                  // اية او نصيحة
                  decoration: BoxDecoration(
                    color: kLightPrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 225,
                  width: 400,
                  child: Center(
                    child: Text(
                      'إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ',
                      style: kHeading2Text,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
