import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/green_contatiner.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/lists.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyRecitationScreen extends StatefulWidget {
  const DailyRecitationScreen({super.key, this.userName});
  static String id = 'daily_recitation_screen';
  final String? userName;
  @override
  State<DailyRecitationScreen> createState() => _DailyRecitationScreenState();
}

class _DailyRecitationScreenState extends State<DailyRecitationScreen> {
  String? selectedWithName;
  String? selectedToName;
  int? selectedButtonIndex;
  List<String> buttonTexts = ['مدارسة', 'تسميع'];
  bool _withVisible = false;
  bool _toVisible = false;
  bool _inputVisible = false;
  bool _saveVisible = false;
  bool _isTeacher = false;

  final TextEditingController firstPageController = TextEditingController();
  final TextEditingController secondPageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWithName = withNames.isNotEmpty ? withNames[0] : null;
    selectedToName = toNames.isNotEmpty ? toNames[0] : null;
    isTeacher();
  }

  List<String> filterNames(List<String> names, String? currentUser) {
    if (currentUser == null) return names;
    final filtered = names.where((name) => name != currentUser).toList();
    return filtered.isNotEmpty ? filtered : names;
  }

  void isTeacher() {
    setState(() {
      if (widget.userName == 'استاذ ابو عبيدة' ||
          widget.userName == 'استاذ عبدالرحمن الخن') {
        _isTeacher = true;
      } else {
        _isTeacher = false;
      }
    });
  }

  void saveData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.displayName == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('الرجاء تسجيل الدخول أولاً')));
      return;
    }

    String? otherUser =
        selectedButtonIndex == 0 ? selectedWithName : selectedToName;
    String firstPage = firstPageController.text;
    String secondPage = secondPageController.text;

    if (otherUser == null || firstPage.isEmpty || secondPage.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('الرجاء ملء جميع الحقول')));
      return;
    }

    try {
      String? otherUserId;

      // Only fetch other user's ID if type is 'with' (selectedButtonIndex == 0)
      if (selectedButtonIndex == 0) {
        final otherUserDoc =
            await FirebaseFirestore.instance
                .collection('usernames')
                .doc(otherUser)
                .get();

        if (!otherUserDoc.exists) {
          throw Exception('المستخدم الآخر غير موجود');
        }
        otherUserId = otherUserDoc.data()!['userId'];
      }

      Map<String, dynamic> data = {
        'first_page': int.tryParse(firstPage) ?? 0,
        'second_page': int.tryParse(secondPage) ?? 0,
        'user': user.displayName!,
        'userId': user.uid,
        'other_User': otherUser,
        'recitation_type': selectedButtonIndex == 0 ? 'with' : 'to',
        'timestamp': FieldValue.serverTimestamp(),
        'status': selectedButtonIndex == 0 ? 'pending' : 'confirmed',
      };

      // Include other_userId only if available
      if (otherUserId != null) {
        data['other_userId'] = otherUserId;
      }

      await FirebaseFirestore.instance.collection('daily_recitation').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            selectedButtonIndex == 0
                ? 'تم إرسال طلب التأكيد إلى $otherUser'
                : 'تم حفظ البيانات بنجاح!',
            textAlign: TextAlign.right,
          ),
        ),
      );

      // Clear inputs and reset UI
      firstPageController.clear();
      secondPageController.clear();
      setState(() {
        selectedButtonIndex = null;
        _withVisible = false;
        _toVisible = false;
        _inputVisible = false;
        _saveVisible = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في حفظ البيانات: $e', textAlign: TextAlign.right),
        ),
      );
    }
  }

  Future<void> _handleConfirmation(String docId, bool accepted) async {
    try {
      await FirebaseFirestore.instance
          .collection('daily_recitation')
          .doc(docId)
          .update({
            'status': accepted ? 'confirmed' : 'rejected',
            'confirmed_at': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accepted ? 'تم تأكيد التسميع بنجاح' : 'تم رفض التسميع',
            textAlign: TextAlign.right,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في تأكيد التسميع: $e', textAlign: TextAlign.right),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
          child: Text(
            'التسميع اليومي',
            style: GoogleFonts.elMessiri(
              textStyle: kHeading2Text.copyWith(color: kPrimaryColor),
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
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 35,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 100),
                  GreenContatiner(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(buttonTexts.length, (
                              index,
                            ) {
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (selectedButtonIndex != index) {
                                        selectedButtonIndex = index;
                                        _withVisible = (index == 0);
                                        _toVisible = (index == 1);
                                        _inputVisible = true;
                                        _saveVisible = true;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color:
                                          selectedButtonIndex == index
                                              ? kLightPrimaryColor
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: kLightPrimaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    height: 35,
                                    width: 105,
                                    child: Text(
                                      buttonTexts[index],
                                      style: GoogleFonts.cairo(
                                        textStyle: kBodySmallTextDark.copyWith(
                                          color:
                                              selectedButtonIndex == index
                                                  ? Colors.white
                                                  : kLightPrimaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: _withVisible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 250,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: kLightPrimaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedWithName,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: kLightPrimaryColor,
                                    ),
                                    iconSize: 24,
                                    elevation: 4,
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodyRegularText.copyWith(),
                                    ),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedWithName = newValue!;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    items:
                                        filterNames(
                                          withNames,
                                          widget.userName,
                                        ).map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(value),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'مع',
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodySmallText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _toVisible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 250,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: kLightPrimaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedToName,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: kLightPrimaryColor,
                                    ),
                                    iconSize: 24,
                                    elevation: 4,
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodyRegularText.copyWith(),
                                    ),
                                    underline: Container(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedToName = newValue!;
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    items:
                                        filterNames(
                                          toNames,
                                          widget.userName,
                                        ).map<DropdownMenuItem<String>>((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(value),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'عند',
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodySmallText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: _inputVisible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RoundedTextField(
                                  controller: firstPageController,
                                  obscure: false,
                                  textColor: kPrimaryTextLight,
                                  textHint: '312',
                                  keyboardType: TextInputType.number,
                                  width: 150,
                                  height: 50,
                                  hintColor: kSecondaryTextLight.withValues(
                                    alpha: (0.199 * 255),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'من صفحة',
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodyRegularText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Visibility(
                            visible: _inputVisible,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RoundedTextField(
                                  controller: secondPageController,
                                  obscure: false,
                                  textColor: kPrimaryTextLight,
                                  textHint: '330',
                                  keyboardType: TextInputType.number,
                                  width: 150,
                                  height: 50,
                                  hintColor: kSecondaryTextLight.withValues(
                                    alpha: (0.199 * 255),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'الى صفحة',
                                    style: GoogleFonts.cairo(
                                      textStyle: kBodyRegularText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          Visibility(
                            visible: _saveVisible,
                            child: Center(
                              child: RoundedButton(
                                buttonText: 'حفظ',
                                isDisabled: _isTeacher,
                                isPrimary: false,
                                onPressed: saveData,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('daily_recitation')
                                    .where(
                                      'other_User',
                                      isEqualTo: widget.userName,
                                    )
                                    .where('recitation_type', isEqualTo: 'with')
                                    .where('status', isEqualTo: 'pending')
                                    .orderBy('timestamp', descending: true)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox();
                              }

                              final pendingItems = snapshot.data!.docs;

                              if (pendingItems.isEmpty) {
                                return const SizedBox();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      'طلبات في انتظار التأكيد',
                                      style: GoogleFonts.elMessiri(
                                        textStyle: kBodyLargeText.copyWith(
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...pendingItems.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: kSecondaryBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          'هل قد قمت بالمدارسة مع ${data['user'].split(' ')[0]} من صفحة ${data['first_page']} الى ${data['second_page']} ؟',
                                          style: GoogleFonts.cairo(
                                            textStyle: kBodySmallText,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        leading: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                              onPressed:
                                                  () => _handleConfirmation(
                                                    doc.id,
                                                    false,
                                                  ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              onPressed:
                                                  () => _handleConfirmation(
                                                    doc.id,
                                                    true,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              );
                            },
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
