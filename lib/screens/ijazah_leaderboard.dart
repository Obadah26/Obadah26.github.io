import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IjazahLeaderboardScreen extends StatefulWidget {
  const IjazahLeaderboardScreen({super.key, this.userName});
  static String id = 'ijazah_leaderboard_screen';
  final String? userName;

  @override
  State<IjazahLeaderboardScreen> createState() =>
      _IjazahLeaderboardScreenState();
}

class _IjazahLeaderboardScreenState extends State<IjazahLeaderboardScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.person_outline, size: 50, color: Colors.white),
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
          Positioned(
            top: -35,
            right: -75,
            child: Container(
              width: 225,
              height: 200,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -35,
            left: -75,
            child: Container(
              width: 225,
              height: 200,
              decoration: BoxDecoration(
                color: kLightPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'إحصائيات الإجازة',
                    style: GoogleFonts.elMessiri(textStyle: kHeading2Text),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kLightPrimaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('ijazah_recitation')
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

                          // Calculate pages for each name
                          Map<String, int> pagesPerName = {};
                          for (var name in withNames) {
                            pagesPerName[name] =
                                0; // Initialize all names with 0
                          }

                          for (var doc in snapshot.data!.docs) {
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
                              String? user = doc['user'];
                              if (user != null && withNames.contains(user)) {
                                pagesPerName.update(
                                  user,
                                  (value) => value + pages,
                                  ifAbsent: () => pages,
                                );
                              }
                            }
                          }

                          return ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: withNames.length,
                            itemBuilder: (context, index) {
                              String name = withNames[index];
                              int totalPages = pagesPerName[name] ?? 0;
                              bool completed = totalPages >= 604;

                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                      textStyle: kBodyRegularText.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  trailing: Text(
                                    completed
                                        ? 'تم إنهاء الإجازة'
                                        : '$totalPages من 604 صفحة',
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodySmallTextDark.copyWith(
                                        fontSize: 16,
                                        color:
                                            completed
                                                ? Colors.green
                                                : kPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
