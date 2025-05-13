import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/lists.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
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

  final TextEditingController firstPageController = TextEditingController();
  final TextEditingController secondPageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedWithName = withNames.isNotEmpty ? withNames[0] : null;
    selectedToName = toNames.isNotEmpty ? toNames[0] : null;
  }

  List<String> filterNames(List<String> names, String? currentUser) {
    if (currentUser == null) return names;
    final filtered = names.where((name) => name != currentUser).toList();
    return filtered.isNotEmpty ? filtered : names;
  }

  void saveData() async {
    String? userName = widget.userName;
    String? otherUser =
        selectedButtonIndex == 0 ? selectedWithName : selectedToName;
    String firstPage = firstPageController.text;
    String secondPage = secondPageController.text;

    if (userName == null ||
        otherUser == null ||
        firstPage.isEmpty ||
        secondPage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء ملء جميع الحقول', textAlign: TextAlign.right),
        ),
      );
      return;
    }

    try {
      Map<String, dynamic> data = {
        'user': userName,
        'first_page': int.tryParse(firstPage) ?? 0,
        'second_page': int.tryParse(secondPage) ?? 0,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (selectedButtonIndex == 0) {
        data['other_User'] = otherUser;
        data['recitation_type'] = 'with';
      } else if (selectedButtonIndex == 1) {
        data['recitation_type'] = 'to';
        data['listened_by'] = otherUser;
      }

      await FirebaseFirestore.instance.collection('daily_recitation').add(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم حفظ البيانات بنجاح!', textAlign: TextAlign.right),
        ),
      );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.group_outlined, size: 35, color: kPrimaryColor),
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
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 35,
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 60),
                  Center(
                    child: Text(
                      'التسميع اليومي',
                      style: GoogleFonts.elMessiri(
                        textStyle: kHeading2Text.copyWith(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kSecondaryColor.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(158, 158, 158, 0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
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
                                          textStyle: kBodySmallTextDark
                                              .copyWith(
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'دارست مع',
                                      style: GoogleFonts.cairo(
                                        textStyle: kBodyRegularText.copyWith(),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'سمعت ل',
                                      style: GoogleFonts.cairo(
                                        textStyle: kBodyRegularText.copyWith(),
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
                                        textStyle: kBodyRegularText.copyWith(),
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
                                        textStyle: kBodyRegularText.copyWith(),
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
                                  isPrimary: false,
                                  onPressed: saveData,
                                ),
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
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
