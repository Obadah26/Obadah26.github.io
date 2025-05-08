import 'package:alhadiqa/screens/menu_screen.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MenuScreen.id);
              },
              icon: Icon(Icons.menu, size: 50, color: Color(0xFFa1aab6)),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Icon(Icons.person_outline, color: Colors.white, size: 50),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
      ),
      bottomNavigationBar: BottomBar(auth: _auth, selectedIndex: 1),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -35,
            left: -75,
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
                      child: Text('أهلاً، فلان', style: kHeading2Text),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text('الخميس، 8 مايو', style: kBodySmallText),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Container(
                      // أفضل 5 المسميعين خلال الشهر
                      height: 225,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color(0xFFe6f2f6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kDarkPrimaryColor, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'أفضل 5 مسمعين خلال الشهر الماضي',
                                style: kBodyLargeTextDark.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: kDarkPrimaryColor,
                                ),
                              ),
                              Text(
                                '1. فلان',
                                style: kBodyRegularTextDark.copyWith(
                                  color: kDarkPrimaryColor,
                                ),
                              ),
                              Text(
                                '2. فلان',
                                style: kBodyRegularTextDark.copyWith(
                                  color: kDarkPrimaryColor,
                                ),
                              ),
                              Text(
                                '3. فلان',
                                style: kBodyRegularTextDark.copyWith(
                                  color: kDarkPrimaryColor,
                                ),
                              ),
                              Text(
                                '4. فلان',
                                style: kBodyRegularTextDark.copyWith(
                                  color: kDarkPrimaryColor,
                                ),
                              ),
                              Text(
                                '5. فلان',
                                style: kBodyRegularTextDark.copyWith(
                                  color: kDarkPrimaryColor,
                                ),
                              ),
                            ],
                          ),
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
                          style: kHeading2TextDark.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
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
                        color: Color(0xFFe6f2f6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: kDarkPrimaryColor, width: 2),
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
