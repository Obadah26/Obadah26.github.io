import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/widgets/green_contatiner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alhadiqa/lists.dart';

class UserDetailsScreen extends StatefulWidget {
  static String id = 'user_details_screen';
  final String? userName;

  const UserDetailsScreen({super.key, this.userName});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String selectedFilter = 'الأسبوع';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: GoogleFonts.elMessiri(textStyle: kHeading2Text),
              children: <TextSpan>[
                TextSpan(
                  text: 'تفاصيل التسميع لـ ',
                  style: GoogleFonts.elMessiri(textStyle: kHeading2Text),
                ),
                TextSpan(
                  text: widget.userName?.split(' ')[0],
                  style: GoogleFonts.elMessiri(
                    textStyle: kHeading1Text,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(
                FlutterIslamicIcons.quran2,
                size: 35,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 35,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 10),
                GreenContatiner(
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    isExpanded: true,
                    underline: Container(),
                    items:
                        timeFilters.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                              child: Text(
                                value,
                                style: GoogleFonts.cairo(
                                  textStyle: kBodyRegularText.copyWith(),
                                ),
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
                  child: GreenContatiner(
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
                              final timestamp = doc['timestamp'] as Timestamp?;
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
                          int pages = (secondPage - firstPage) + 1;

                          if (pages > 0) {
                            String recitationType =
                                doc['recitation_type'] ?? '';
                            String status = doc['status'] ?? '';

                            if (recitationType == 'to') {
                              totalPages += pages;
                              totalRecitations++;
                            } else if (recitationType == 'with' &&
                                status == 'confirmed') {
                              totalPages += pages;
                              totalRecitations++;
                            }

                            // For your recitationDetails list, keep same logic to show partners, etc.
                            String partner = '';
                            String listenedBy = '';
                            final data = doc.data() as Map<String, dynamic>;

                            if (recitationType == 'with') {
                              partner =
                                  doc['user'] == widget.userName
                                      ? doc['other_User']
                                      : doc['user'];
                            } else if (recitationType == 'to') {
                              partner =
                                  data.containsKey('other_User')
                                      ? (data['other_User'] ?? '')
                                      : '';
                              listenedBy =
                                  data.containsKey('listened_by')
                                      ? (data['listened_by'] ?? '')
                                      : '';
                            }

                            recitationDetails.add({
                              'date': doc['timestamp'].toDate(),
                              'pages': pages,
                              'type':
                                  recitationType.isEmpty
                                      ? 'فردي'
                                      : recitationType,
                              'with': partner,
                              'listened_by': listenedBy,
                            });
                          }
                        }

                        return Column(
                          children: [
                            Card(
                              elevation: 3,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: kSecondaryBorderColor,
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
                                              'إجمالي التسميع',
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
                                              textDirection: TextDirection.rtl,
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
                                  final doc = filteredDocs[index];
                                  String recitationType =
                                      doc['recitation_type'] ?? '';
                                  String status = doc['status'] ?? '';

                                  // Skip card if type is 'with' but status is NOT 'confirmed'
                                  if (recitationType == 'with' &&
                                      status != 'confirmed') {
                                    return SizedBox.shrink();
                                  }
                                  int firstPage =
                                      doc['first_page'] is String
                                          ? int.tryParse(doc['first_page']) ?? 0
                                          : (doc['first_page'] as int? ?? 0);
                                  int secondPage =
                                      doc['second_page'] is String
                                          ? int.tryParse(doc['second_page']) ??
                                              0
                                          : (doc['second_page'] as int? ?? 0);
                                  return Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: kSecondaryBorderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'من صفحة $firstPage إلى $secondPage',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodySmallText,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text(
                                                  recitation['date']
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: GoogleFonts.cairo(
                                                    textStyle: kBodyRegularText
                                                        .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              kLightPrimaryColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                textDirection:
                                                    TextDirection.rtl,
                                                '${recitation['pages']} صفحة',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodyRegularText
                                                      .copyWith(
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                recitation['type'] == 'with'
                                                    ? 'نوع التسميع: مدارسة'
                                                    : 'نوع التسميع: تسميع',
                                                style: GoogleFonts.cairo(
                                                  textStyle: kBodySmallText
                                                      .copyWith(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              if (recitation['type'] ==
                                                      'with' &&
                                                  recitation['with']
                                                          ?.isNotEmpty ==
                                                      true)
                                                Text(
                                                  'مع ${recitation['with']}',
                                                  style: GoogleFonts.cairo(
                                                    textStyle: kBodySmallText
                                                        .copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              if (recitation['type'] == 'to' &&
                                                  recitation['with']
                                                          ?.isNotEmpty ==
                                                      true)
                                                Text(
                                                  'عند ${recitation['with']}',
                                                  style: GoogleFonts.cairo(
                                                    textStyle: kBodySmallText
                                                        .copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              if (recitation['type'] == 'to' &&
                                                  recitation['listened_by']
                                                          ?.isNotEmpty ==
                                                      true)
                                                Text(
                                                  ' عند: ${recitation['listened_by']}',
                                                  style: GoogleFonts.cairo(
                                                    textStyle: kBodySmallText
                                                        .copyWith(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                            ],
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
        ],
      ),
    );
  }
}
