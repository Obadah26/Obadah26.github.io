import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/user_detials_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecitationLeaderboardScreen extends StatefulWidget {
  const RecitationLeaderboardScreen({super.key, this.userName});
  static String id = 'recitation_leaderboard_screen';
  final String? userName;

  @override
  State<RecitationLeaderboardScreen> createState() =>
      _RecitationLeaderboardScreenState();
}

class _RecitationLeaderboardScreenState
    extends State<RecitationLeaderboardScreen> {
  final List<String> withNames = [
    'أحمد',
    'أويس',
    'بدر',
    'حازم',
    'خالد',
    'سارية',
    'عبادة',
    'عبيدة',
    'عبدالرحمن أبو سعدة',
    'عبدالرحمن رعد',
    'عروة',
    'عمر',
    'عمرو',
    'فايز',
    'مجد',
    'زيد',
  ];

  String selectedFilter = 'الأسبوع';
  final List<String> timeFilters = [
    'منذ انشاء التطبيق',
    'اليوم',
    'الأسبوع',
    'الشهر',
    'ثلاثة أشهر',
    'السنة',
  ];

  void sortWithNames(Map<String, int> pagesPerName) {
    withNames.sort(
      (a, b) => (pagesPerName[b] ?? 0).compareTo(pagesPerName[a] ?? 0),
    );
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
            child: Icon(
              Icons.group_outlined,
              size: 50,
              color: kLightPrimaryColor,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.id,
                (route) => false,
              );
            },
            icon: Icon(Icons.arrow_back_rounded, size: 50),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'إحصائيات التسميع',
                    style: GoogleFonts.elMessiri(textStyle: kHeading2Text),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kLightPrimaryColor, width: 1.5),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      underline: Container(),
                      items:
                          timeFilters.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.cairo(
                                  textStyle: kBodyRegularText.copyWith(),
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedFilter = newValue!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kLightPrimaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(158, 158, 158, 0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('daily_recitation')
                                .where('user', isEqualTo: widget.userName)
                                .orderBy('timestamp', descending: true)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('حدث خطأ: ${snapshot.error}'),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: Text(
                                'لا توجد تسميعات مسجلة بعد',
                                style: GoogleFonts.cairo(
                                  textStyle: kBodyRegularText,
                                ),
                              ),
                            );
                          }

                          final now = DateTime.now();
                          final filteredDocs =
                              snapshot.data!.docs.where((doc) {
                                final timestamp =
                                    doc['timestamp'] as Timestamp?;
                                if (timestamp == null) return false;

                                final date = timestamp.toDate();

                                switch (selectedFilter) {
                                  case 'اليوم':
                                    return date.isAfter(
                                      now.subtract(Duration(days: 1)),
                                    );
                                  case 'الأسبوع':
                                    return date.isAfter(
                                      now.subtract(Duration(days: 7)),
                                    );
                                  case 'الشهر':
                                    return date.isAfter(
                                      now.subtract(Duration(days: 30)),
                                    );
                                  case '3 أشهر':
                                    return date.isAfter(
                                      now.subtract(Duration(days: 90)),
                                    );
                                  case 'السنة':
                                    return date.isAfter(
                                      now.subtract(Duration(days: 365)),
                                    );
                                  default:
                                    return true;
                                }
                              }).toList();

                          Map<String, int> pagesPerName = {};
                          int totalUserPages = 0;

                          for (var doc in filteredDocs) {
                            int firstPage =
                                doc['first_page'] is String
                                    ? int.tryParse(doc['first_page']) ?? 0
                                    : (doc['first_page'] as int? ?? 0);
                            int secondPage =
                                doc['second_page'] is String
                                    ? int.tryParse(doc['second_page']) ?? 0
                                    : (doc['second_page'] as int? ?? 0);
                            int pages = secondPage - firstPage;

                            if (pages > 0) {
                              totalUserPages += pages;

                              if ((doc['recitation_type'] ?? '') == 'with' &&
                                  doc['other_User'] != null) {
                                String otherUser = doc['other_User'];
                                pagesPerName.update(
                                  otherUser,
                                  (value) => value + pages,
                                  ifAbsent: () => pages,
                                );
                              }
                            }
                          }

                          Map<String, List<Timestamp>> recitationDates = {};

                          for (var doc in filteredDocs) {
                            int firstPage =
                                doc['first_page'] is String
                                    ? int.tryParse(doc['first_page']) ?? 0
                                    : (doc['first_page'] as int? ?? 0);
                            int secondPage =
                                doc['second_page'] is String
                                    ? int.tryParse(doc['second_page']) ?? 0
                                    : (doc['second_page'] as int? ?? 0);
                            int pages = secondPage - firstPage;

                            if (pages > 0) {
                              if ((doc['recitation_type'] ?? '') == 'with' &&
                                  doc['other_User'] != null) {
                                String otherUser = doc['other_User'];
                                Timestamp time = doc['timestamp'];

                                pagesPerName.update(
                                  otherUser,
                                  (v) => v + pages,
                                  ifAbsent: () => pages,
                                );
                                recitationDates
                                    .putIfAbsent(otherUser, () => [])
                                    .add(time);
                              }
                            }
                          }

                          sortWithNames(pagesPerName);

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => UserDetailsScreen(
                                            userName: widget.userName,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    title: Text(
                                      'إجمالي تسميعاتك',
                                      style: GoogleFonts.cairo(
                                        textStyle: kBodyRegularText.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    trailing: Text(
                                      '$totalUserPages صفحة',
                                      style: GoogleFonts.cairo(
                                        textStyle: kBodySmallTextDark.copyWith(
                                          fontSize: 16,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  itemCount: withNames.length,
                                  itemBuilder: (context, index) {
                                    String name = withNames[index];
                                    int totalPages = pagesPerName[name] ?? 0;

                                    if (totalPages == 0) {
                                      return SizedBox.shrink();
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        String selectedUser = name;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => UserDetailsScreen(
                                                  userName: selectedUser,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          side: BorderSide(
                                            color: kLightPrimaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          title: Text(
                                            name,
                                            style: GoogleFonts.cairo(
                                              textStyle: kBodyRegularText
                                                  .copyWith(fontSize: 18),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          trailing: Text(
                                            '$totalPages صفحة',
                                            style: GoogleFonts.cairo(
                                              textStyle: kBodySmallTextDark
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
