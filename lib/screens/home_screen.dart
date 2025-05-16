import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:alhadiqa/lists.dart';
import 'package:alhadiqa/widgets/mutual_recitation_status.dart';
import 'package:alhadiqa/notification_service.dart';
import 'package:alhadiqa/screens/azkar_screen.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/screens/notification_screen.dart';
import 'package:alhadiqa/screens/pending_confirmations_screen.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';
import 'package:alhadiqa/widgets/home_button.dart';
import 'package:alhadiqa/widgets/profile_drawer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:rxdart/rxdart.dart';

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
  bool _loadingUser = true;
  bool _isTeacher = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadArabicDate();
  }

  void getCurrentUser() async {
    setState(() => _loadingUser = true);
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        await user.reload();
        final refreshedUser = _auth.currentUser;
        setState(() {
          _userName = refreshedUser?.displayName ?? "User";
          if (_userName == 'استاذ ابو عبيدة' ||
              _userName == 'استاذ عبدالرحمن الخن') {
            _isTeacher = true;
          } else {
            _isTeacher = false;
          }
        });
      }

      if (_userName == "User") {
        final doc = await _firestore.collection('users').doc(user?.uid).get();
        if (doc.exists) {
          setState(() {
            _userName = doc['username'] ?? "User";
            if (_userName == 'استاذ ابو عبيدة' ||
                _userName == 'استاذ عبدالرحمن الخن') {
              _isTeacher = true;
            } else {
              _isTeacher = false;
            }
          });
        }
      }
    } catch (e) {
      print("Error getting user: $e");
      setState(() {
        _userName = "User";
      });
    }
    setState(() => _loadingUser = false);
  }

  Future<void> _loadArabicDate() async {
    setState(() {
      arabicDate = DateFormat('EEEE، d MMMM', 'ar').format(DateTime.now());
    });
  }

  Widget _buildSectionContainer(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(128, 128, 128, 0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color.fromRGBO(76, 175, 80, 0.3)),
      ),
      child: child,
    );
  }

  MapEntry<String, String> _getDailyAsar() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 5, 14)).inDays;
    final index = dayOfYear % asar.length;
    return asar.entries.elementAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<int>(
              stream: Stream.periodic(const Duration(seconds: 30)).asyncMap((
                _,
              ) async {
                return await NotificationService.getUnreadCount();
              }),
              initialData: null,
              builder: (context, snapshot) {
                final isLoading =
                    snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none;

                final unreadCount = snapshot.data ?? 0;

                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -4, end: -2),
                  badgeContent:
                      isLoading
                          ? const SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            unreadCount > 9 ? '9+' : unreadCount.toString(),
                            style: GoogleFonts.cairo(
                              textStyle: kBodySmallTextDark.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                  showBadge: isLoading || unreadCount > 0,
                  badgeStyle: badges.BadgeStyle(
                    badgeColor: kDarkPrimaryColor,
                    padding: const EdgeInsets.all(5),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NotificationScreen.id);
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 30,
                      color: kDarkPrimaryColor,
                    ),
                    tooltip: 'الإشعارات',
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.menu, color: kDarkPrimaryColor, size: 30),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder:
                //         (context) =>
                //             MenuScreen(auth: _auth, userName: _userName),
                //   ),
                // );
              },
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('daily_recitation')
                    .where(
                      'user',
                      isEqualTo: _userName,
                    ) // Pending confirmations for the user
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
            builder: (context, snapshot) {
              final pendingCount =
                  snapshot.hasData ? snapshot.data!.docs.length : 0;

              return badges.Badge(
                position: badges.BadgePosition.topEnd(top: -4, end: -2),
                badgeContent:
                    pendingCount == 0
                        ? null
                        : Text(
                          pendingCount > 9 ? '9+' : pendingCount.toString(),
                          style: GoogleFonts.cairo(
                            textStyle: kBodySmallTextDark.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ),
                showBadge:
                    pendingCount > 0, // Only show if there's a pending count
                badgeStyle: badges.BadgeStyle(
                  badgeColor: kDarkPrimaryColor,
                  padding: const EdgeInsets.all(5),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PendingConfirmationsScreen(userName: _userName),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.checklist_rounded,
                    color: kDarkPrimaryColor,
                    size: 30,
                  ),
                  tooltip: 'الملف الشخصي',
                ),
              );
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
      ),
      endDrawer: ProfileDrawer(userName: _userName, auth: _auth),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Greeting Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'أهلاً، ',
                      style: GoogleFonts.cairo(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: _loadingUser ? '...جاري التحميل' : _userName,
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kDarkPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    arabicDate,
                    style: GoogleFonts.elMessiri(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MutualRecitationStatus(userName: _userName),
            // Daily Ayah Section
            _buildSectionContainer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'آثار يومية',
                    style: GoogleFonts.elMessiri(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Text(
                        _getDailyAsar().key,
                        style: GoogleFonts.notoKufiArabic(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kLightPrimaryColor,
                            height: 1.8,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getDailyAsar().value,
                        style: GoogleFonts.notoKufiArabic(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Weekly Target Section
            Visibility(
              visible: _isTeacher ? false : true,
              child: _buildSectionContainer(
                StreamBuilder<List<QueryDocumentSnapshot>>(
                  stream: Rx.combineLatest2<
                    QuerySnapshot,
                    QuerySnapshot,
                    List<QueryDocumentSnapshot>
                  >(
                    _firestore
                        .collection('daily_recitation')
                        .where('user', isEqualTo: _userName)
                        .where('recitation_type', whereIn: ['to', 'with'])
                        .where('status', isEqualTo: 'confirmed')
                        .snapshots(),
                    _firestore
                        .collection('daily_recitation')
                        .where('other_User', isEqualTo: _userName)
                        .where('recitation_type', whereIn: ['to', 'with'])
                        .where('status', isEqualTo: 'confirmed')
                        .snapshots(),
                    (snapshot1, snapshot2) {
                      // Merge docs from both snapshots into a single list
                      final combinedDocs = <QueryDocumentSnapshot>[];
                      combinedDocs.addAll(snapshot1.docs);
                      combinedDocs.addAll(snapshot2.docs);
                      return combinedDocs;
                    },
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: kPrimaryColor),
                      );
                    }

                    int totalPages = 0;
                    final docs = snapshot.data!;

                    for (var doc in docs) {
                      int firstPage =
                          doc['first_page'] is String
                              ? int.tryParse(doc['first_page']) ?? 0
                              : (doc['first_page'] as int? ?? 0);
                      int secondPage =
                          doc['second_page'] is String
                              ? int.tryParse(doc['second_page']) ?? 0
                              : (doc['second_page'] as int? ?? 0);
                      totalPages += ((secondPage - firstPage) + 1);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'الهدف الاسبوعي',
                          style: GoogleFonts.elMessiri(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkPrimaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'تم انجاز '),
                              TextSpan(
                                text: '$totalPages',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              TextSpan(text: ' صفحة من أصل 40 صفحة'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressBar(
                          maxSteps: 40,
                          progressType: LinearProgressBar.progressTypeLinear,
                          currentStep: totalPages,
                          progressColor: kLightPrimaryColor,
                          backgroundColor: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              '40',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          totalPages <= 10
                              ? 'الصبر والمداومة مفتاح النجاح في حفظ كتاب الله'
                              : totalPages <= 20
                              ? 'القليل الدائم خير من الكثير المنقطع'
                              : totalPages <= 30
                              ? 'استمر في الإنجاز'
                              : totalPages <= 39
                              ? 'خطوات قليلة تفصلك عن الهدف'
                              : 'مبارك! لقد أتممت الهدف',
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            _buildSectionContainer(
              Column(
                children: [
                  Text(
                    'الخدمات السريعة',
                    style: GoogleFonts.elMessiri(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      HomeButton(
                        icon: FlutterIslamicIcons.muslim2,
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
                        icon: Icons.bar_chart,
                        text: 'نتائج التسميع',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => RecitationLeaderboardScreen(
                                    userName: _userName,
                                  ),
                            ),
                          );
                        },
                      ),
                      HomeButton(
                        icon: FlutterIslamicIcons.tasbihHand,
                        text: 'الاذكار',
                        onPressed: () {
                          Navigator.pushNamed(context, AzkarScreen.id);
                        },
                      ),
                      HomeButton(
                        icon: FlutterIslamicIcons.quran2,
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
                        icon: Icons.bar_chart,
                        text: 'نتائج الاجازة',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => IjazahLeaderboardScreen(
                                    userName: _userName,
                                  ),
                            ),
                          );
                        },
                      ),
                      HomeButton(
                        icon: FlutterIslamicIcons.lantern,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
