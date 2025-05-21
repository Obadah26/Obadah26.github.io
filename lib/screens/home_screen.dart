import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:alhadiqa/widgets/green_contatiner.dart';
import 'package:alhadiqa/widgets/mutual_recitation_status.dart';
import 'package:alhadiqa/notification_service.dart';
import 'package:alhadiqa/screens/azkar_screen.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/notification_screen.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';
import 'package:alhadiqa/widgets/home_button.dart';
import 'package:alhadiqa/widgets/profile_drawer.dart';
import 'package:alhadiqa/widgets/top_5_users.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:alhadiqa/daily_quotes_service.dart';

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
  MapEntry<String, String> _dailyQuote = const MapEntry('', '');
  String arabicDate = '';
  String _userName = '';
  bool _loadingUser = true;
  bool _isTeacher = false;
  int weeklyGoal = 40;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _loadArabicDate();
    _loadWeeklyGoal();
    _loadDailyQuote();
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
          if (_userName == 'أستاذ أبو عبيدة' ||
              _userName == 'أستاذ عبدالرحمن الخن') {
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
            if (_userName == 'أستاذ أبو عبيدة' ||
                _userName == 'أستاذ عبدالرحمن الخن') {
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

  Future<void> _loadDailyQuote() async {
    final quote = await DailyQuotesService.getTodaysQuote();
    setState(() => _dailyQuote = quote);
  }

  void _loadWeeklyGoal() {
    final storage = GetStorage();
    setState(() {
      weeklyGoal = storage.read('weeklyGoal') ?? 40;
    });
  }

  Stream<List<MapEntry<String, int>>> getTop5UsersThisMonthStream() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    return _firestore
        .collection('daily_recitation')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth),
        )
        .where('timestamp', isLessThan: Timestamp.fromDate(firstDayOfNextMonth))
        .snapshots()
        .map((snapshot) {
          Map<String, int> pagesPerUser = {};

          for (var doc in snapshot.docs) {
            int firstPage = 0;
            int secondPage = 0;
            try {
              firstPage =
                  doc['first_page'] is String
                      ? int.tryParse(doc['first_page']) ?? 0
                      : (doc['first_page'] as int? ?? 0);
              secondPage =
                  doc['second_page'] is String
                      ? int.tryParse(doc['second_page']) ?? 0
                      : (doc['second_page'] as int? ?? 0);
            } catch (_) {}

            int pages = (secondPage - firstPage) + 1;
            if (pages <= 0) continue;

            String user = doc['user'] ?? '';
            String recitationType = doc['recitation_type'] ?? '';
            String status = doc['status'] ?? '';

            if (recitationType == 'to') {
              pagesPerUser.update(
                user,
                (value) => value + pages,
                ifAbsent: () => pages,
              );
            } else if (recitationType == 'with' && status == 'confirmed') {
              pagesPerUser.update(
                user,
                (value) => value + pages,
                ifAbsent: () => pages,
              );
              if (doc['other_User'] != null) {
                String otherUser = doc['other_User'];
                pagesPerUser.update(
                  otherUser,
                  (value) => value + pages,
                  ifAbsent: () => pages,
                );
              }
            }
          }

          var sortedList =
              pagesPerUser.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

          return sortedList.take(5).toList();
        });
  }

  Future<void> _loadArabicDate() async {
    setState(() {
      arabicDate = DateFormat('EEEE، d MMMM', 'ar').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Center(
          child: Text(
            'الرئيسية',
            style: GoogleFonts.elMessiri(
              textStyle: kHeading2Text.copyWith(color: kDarkPrimaryColor),
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 15, 0),
              child: IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: kDarkPrimaryColor,
                  size: 30,
                ),
                onPressed: () {
                  if (_userName.isNotEmpty && _userName != '...جاري التحميل') {
                    _scaffoldKey.currentState?.openEndDrawer();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'يرجى الانتظار حتى يتم تحميل اسم المستخدم',
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
          child: StreamBuilder<int>(
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
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
      ),
      endDrawer: ProfileDrawer(
        userName: _userName,
        auth: _auth,
        isTeacher: _isTeacher,
        loadWeeklyGoal: _loadWeeklyGoal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Greeting Section
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 24, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText.rich(
                    TextSpan(
                      text: 'أهلاً، ',
                      style: kBodyLargeText.copyWith(fontSize: 20),
                      children: [
                        TextSpan(
                          text: _loadingUser ? '...جاري التحميل' : _userName,
                          style: kBodyLargeText.copyWith(
                            fontSize: 20,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    arabicDate,
                    style: kBodySmallText.copyWith(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            MutualRecitationStatus(userName: _userName),
            // Best 5 students
            StreamBuilder<List<MapEntry<String, int>>>(
              stream: getTop5UsersThisMonthStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  );
                }
                final top5Users = snapshot.data!;
                if (top5Users.isEmpty) {
                  return GreenContatiner(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'أفضل 5 مسمعين خلال الشهر الحالي',
                          style: kHeading2Text.copyWith(
                            fontSize: 16,
                            color: kDarkPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'لم يتم تسجيل أي تسميع',
                          style: kBodySmallText.copyWith(
                            fontSize: 15,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  );
                }
                return Top5Users(topUsers: top5Users);
              },
            ),
            // Daily Ayah Section
            GreenContatiner(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'آثار يومية',
                    style: kHeading2Text.copyWith(
                      fontSize: 18,
                      color: kDarkPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children: [
                      Text(
                        _dailyQuote.key,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoKufiArabic(
                          textStyle: TextStyle(
                            fontSize: 22,
                            color: kLightPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _dailyQuote.value,
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
              child: GreenContatiner(
                child: StreamBuilder<List<QueryDocumentSnapshot>>(
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
                          style: kHeading2Text.copyWith(
                            fontSize: 18,
                            color: kDarkPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: kBodyRegularText.copyWith(
                              color: Colors.grey[700],
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
                              TextSpan(text: ' صفحة من أصل $weeklyGoal صفحة'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressBar(
                          maxSteps: weeklyGoal,
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
                              '$weeklyGoal',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          totalPages <= (weeklyGoal * 0.25)
                              ? 'الصبر والمداومة مفتاح النجاح في حفظ كتاب الله'
                              : totalPages <= (weeklyGoal * 0.5)
                              ? 'القليل الدائم خير من الكثير المنقطع'
                              : totalPages <= (weeklyGoal * 0.75)
                              ? 'استمر في الإنجاز'
                              : totalPages <= (weeklyGoal * 0.75)
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
            // Fast buttons
            GreenContatiner(
              child: Column(
                children: [
                  Text(
                    'الخدمات السريعة',
                    style: kHeading2Text.copyWith(
                      fontSize: 18,
                      color: kDarkPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isTeacher)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HomeButton(
                              icon: Icons.bar_chart,
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
                              icon: FlutterIslamicIcons.tasbihHand,
                              text: 'الاذكار',
                              onPressed: () {
                                Navigator.pushNamed(context, AzkarScreen.id);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                  if (!_isTeacher)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      children: [
                        HomeButton(
                          icon: FlutterIslamicIcons.quran2,
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
                          icon: FlutterIslamicIcons.muslim2,
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
