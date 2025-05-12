import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

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
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_outlined, size: 30),
                ),
                IconButton(
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
              ],
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Icon(
            Icons.person_outline,
            color: kLightPrimaryColor,
            size: 50,
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
                                  color: kLightPrimaryColor,
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
                      constraints: BoxConstraints(maxWidth: 350, minWidth: 200),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'اية يومية',
                                  style: GoogleFonts.elMessiri(
                                    textStyle: kBodyLargeText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ',
                                  style: GoogleFonts.notoKufiArabic(
                                    textStyle: kHeading2Text.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: kLightPrimaryColor,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          _firestore
                              .collection('daily_recitation')
                              .where('user', isEqualTo: _userName)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        int totalPages = 0;
                        final docs = snapshot.data!.docs;

                        for (var doc in docs) {
                          int firstPage =
                              doc['first_page'] is String
                                  ? int.tryParse(doc['first_page']) ?? 0
                                  : (doc['first_page'] as int? ?? 0);
                          int secondPage =
                              doc['second_page'] is String
                                  ? int.tryParse(doc['second_page']) ?? 0
                                  : (doc['second_page'] as int? ?? 0);
                          totalPages += (secondPage - firstPage);
                        }

                        double progressPercentage =
                            (totalPages / 40).clamp(0.0, 1.0).toDouble();

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: kSecondaryColor,
                              width: 2,
                            ),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: 350,
                            minWidth: 200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'الهدف الاسبوعي',
                                  style: GoogleFonts.elMessiri(
                                    textStyle: kBodyLargeText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'تم انجاز $totalPages صفحة من اصل 40 صفحة',
                                  style: GoogleFonts.cairo(
                                    textStyle: kBodyRegularText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: 250,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kSecondaryColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressBar(
                                        maxSteps: 40,
                                        progressType:
                                            LinearProgressBar
                                                .progressTypeLinear,
                                        currentStep: totalPages,
                                        progressColor: kLightPrimaryColor,
                                        backgroundColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  totalPages <= 10
                                      ? 'القليل الدائم خير من الكثير المنقطع'
                                      : totalPages <= 20
                                      ? 'استمر في الإنجاز'
                                      : totalPages <= 30
                                      ? 'أحسنت! زد من همتك'
                                      : totalPages <= 39
                                      ? 'بقيت خطوات قليلة'
                                      : 'مبارك! لقد أتممت الهدف',
                                  style: GoogleFonts.cairo(
                                    textStyle: kBodySmallText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                      constraints: BoxConstraints(maxWidth: 350, minWidth: 200),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HomeButton(
                                  icon: Icons.group,
                                  text: 'التسميع اليومي',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DailyRecitationScreen(
                                              userName: _userName,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                HomeButton(
                                  icon: Icons.person,
                                  text: 'الاجازة',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => IjazahRecitationScreen(
                                              userName: _userName,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                HomeButton(
                                  icon: Icons.mosque,
                                  text: 'الاذكار',
                                  onPressed: () {
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   IjazahRecitationScreen.id,
                                    // );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                HomeButton(
                                  icon: Icons.leaderboard,
                                  text: 'نتائج التسميع',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                RecitationLeaderboardScreen(
                                                  userName: _userName,
                                                ),
                                      ),
                                    );
                                  },
                                ),
                                HomeButton(
                                  icon: Icons.leaderboard,
                                  text: 'نتائج الاجازة',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                IjazahLeaderboardScreen(
                                                  userName: _userName,
                                                ),
                                      ),
                                    );
                                  },
                                ),
                                HomeButton(
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
                          ],
                        ),
                      ),
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

class HomeButton extends StatelessWidget {
  const HomeButton({
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
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 50, color: kLightPrimaryColor),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: GoogleFonts.cairo(
                textStyle: kBodySmallText.copyWith(
                  color: kLightPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
