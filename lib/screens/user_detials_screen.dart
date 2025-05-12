import 'package:alhadiqa/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsScreen extends StatefulWidget {
  static String id = 'user_details_screen';
  final String? userName;

  const UserDetailsScreen({super.key, this.userName});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String selectedFilter = 'الأسبوع';
  final List<String> timeFilters = [
    'منذ انشاء التطبيق',
    'اليوم',
    'الأسبوع',
    'الشهر',
    'ثلاثة أشهر',
    'السنة',
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
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: kLightPrimaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                    'تفاصيل التسميع لـ ${widget.userName}',
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
                                .where(
                                  Filter.or(
                                    Filter('user', isEqualTo: widget.userName),
                                    Filter(
                                      'other_User',
                                      isEqualTo: widget.userName,
                                    ),
                                  ),
                                )
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
                                  case 'ثلاثة أشهر':
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

                          int totalPages = 0;
                          int totalRecitations = 0;
                          List<Map<String, dynamic>> recitationDetails = [];

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
                              totalPages += pages;
                              totalRecitations++;

                              String partner = '';
                              if (doc['recitation_type'] == 'with') {
                                partner =
                                    doc['user'] == widget.userName
                                        ? doc['other_User']
                                        : doc['user'];
                              }

                              recitationDetails.add({
                                'date': doc['timestamp'].toDate(),
                                'pages': pages,
                                'type': doc['recitation_type'] ?? 'فردي',
                                'with': partner.isNotEmpty ? partner : '--',
                              });
                            }
                          }

                          return Column(
                            children: [
                              Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: kPrimaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'إجمالي التسميعات',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodyRegularText
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                '$totalRecitations',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodySmallTextDark
                                                      .copyWith(
                                                        fontSize: 20,
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'إجمالي الصفحات',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodyRegularText
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                '$totalPages صفحة',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodySmallTextDark
                                                      .copyWith(
                                                        fontSize: 20,
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Divider(color: kLightPrimaryColor),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'متوسط الصفحات',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodyRegularText
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                totalRecitations > 0
                                                    ? (totalPages /
                                                            totalRecitations)
                                                        .toStringAsFixed(1)
                                                    : '0',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodySmallTextDark
                                                      .copyWith(
                                                        fontSize: 20,
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'آخر تسميع',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodyRegularText
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                filteredDocs.isNotEmpty
                                                    ? (filteredDocs.first.data()
                                                            as Map<
                                                              String,
                                                              dynamic
                                                            >)['timestamp']
                                                        .toDate()
                                                        .toString()
                                                        .substring(0, 10)
                                                    : '--',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodySmallTextDark
                                                      .copyWith(
                                                        fontSize: 16,
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10),
                                  itemCount: recitationDetails.length,
                                  itemBuilder: (context, index) {
                                    final recitation = recitationDetails[index];
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
                                          recitation['date']
                                              .toString()
                                              .substring(0, 10),
                                          style: GoogleFonts.cairo(
                                            textStyle: kBodyRegularText
                                                .copyWith(fontSize: 16),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        subtitle: Text(
                                          'مع ${recitation['with']}',
                                          style: GoogleFonts.cairo(
                                            textStyle: kBodySmallText.copyWith(
                                              fontSize: 14,
                                            ),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${recitation['pages']} صفحة',
                                              style: GoogleFonts.cairo(
                                                textStyle: kBodySmallText
                                                    .copyWith(
                                                      fontSize: 16,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                            Text(
                                              recitation['type'] == 'with'
                                                  ? ':تسميع مشترك'
                                                  : ':تسميع فردي',
                                              style: GoogleFonts.cairo(
                                                textStyle: kBodySmallText
                                                    .copyWith(fontSize: 12),
                                              ),
                                            ),
                                          ],
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
