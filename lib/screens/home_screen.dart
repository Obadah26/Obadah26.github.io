import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  String arabicDate = '';
  String _userName = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadArabicDate();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          _userName = user.displayName ?? "User";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadArabicDate() async {
    await initializeDateFormatting('ar', null);
    setState(() {
      arabicDate = DateFormat('EEEE، d MMMM', 'ar').format(DateTime.now());
    });
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            MenuScreen(auth: _auth, userName: _userName),
                  ),
                );
              },
              icon: Icon(Icons.menu, size: 50),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Icon(Icons.person_outline, color: Colors.white, size: 50),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 225,
              decoration: BoxDecoration(
                color: kSecondaryColor,
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
                    // Hi Text
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text.rich(
                        TextSpan(
                          text: 'أهلاً',
                          style: GoogleFonts.cairo(
                            color: kPrimaryTextLight,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(
                              text: '،',
                              style: GoogleFonts.cairo(
                                textStyle: kHeading1Text,
                              ),
                            ),
                            TextSpan(
                              text: ' $_userName',
                              style: GoogleFonts.cairo(
                                textStyle: kHeading1Text.copyWith(
                                  color: kSecondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    // Date
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        arabicDate,
                        style: GoogleFonts.elMessiri(textStyle: kBodySmallText),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    // Ayah
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kSecondaryColor, width: 2),
                      ),
                      height: 150,
                      width: 300,
                      child: Center(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'اية يومية',
                                  style: GoogleFonts.elMessiri(
                                    textStyle: kBodyLargeText,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ',
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle: kHeading2Text.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '[الحجر: 9]',
                                style: GoogleFonts.notoKufiArabic(
                                  textStyle: kBodySmallText.copyWith(),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    // Weekly Target
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kSecondaryColor, width: 2),
                      ),
                      height: 150,
                      width: 300,
                      child: Column(
                        children: [
                          Text('الهدف الاسبوعي'),
                          Text('تم انجاز 5 صفحات من اصل 40 صفحة'),
                          //Progress bar
                          Text('لم يتبقى الكثير'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    // Buttons
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kSecondaryColor, width: 2),
                      ),
                      height: 250,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HomeButton(),
                              HomeButton(),
                              HomeButton(),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HomeButton(),
                              HomeButton(),
                              HomeButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
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

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          color: Colors.white,
          icon: Icon(Icons.book, size: 50, color: kLightPrimaryColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                'زر',
                style: GoogleFonts.cairo(
                  textStyle: kBodySmallText.copyWith(
                    color: kLightPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
