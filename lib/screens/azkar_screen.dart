import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alhadiqa/lists.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});
  static String id = 'azkar_screen';
  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  int _currentIndex = 0;
  bool _isMorning = true;

  Map<String, Map<String, dynamic>> get currentAzkar =>
      _isMorning ? azkarAsbah : azkarAlmasa;
  List<String> get currentTitles => currentAzkar.keys.toList();

  void _nextZikr() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % currentTitles.length;
    });
  }

  void _previousZikr() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % currentTitles.length;
    });
  }

  void _toggleAzkarType() {
    setState(() {
      _isMorning = !_isMorning;
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = currentTitles[_currentIndex];
    final text = currentAzkar[title]?['النص'] ?? '';
    final repeats = currentAzkar[title]?['عدد التكرار'] ?? 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.popAndPushNamed(context, HomeScreen.id),
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 35,
              color: kDarkPrimaryColor,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kDarkPrimaryColor, width: 2),
              ),
              child: IconButton(
                onPressed: _previousZikr,
                icon: Icon(Icons.arrow_back, color: kDarkPrimaryColor),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kDarkPrimaryColor, width: 2),
              ),
              child: IconButton(
                onPressed: _nextZikr,
                icon: Icon(Icons.arrow_forward, color: kDarkPrimaryColor),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedButton(
                    width: 150,
                    onPressed: _isMorning ? null : _toggleAzkarType,
                    buttonText: 'أذكار الصباح',
                    isPrimary: _isMorning ? true : false,
                  ),
                  const SizedBox(width: 16),
                  RoundedButton(
                    width: 150,
                    onPressed: _isMorning ? _toggleAzkarType : null,
                    buttonText: 'أذكار المساء',
                    isPrimary: _isMorning ? false : true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _isMorning ? 'أذكار الصباح' : 'أذكار المساء',
                style: GoogleFonts.elMessiri(
                  textStyle: kHeading1Text.copyWith(color: kDarkPrimaryColor),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: kMainBorderColor, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.cairo(
                              textStyle: kHeading2Text.copyWith(
                                color: kPrimaryColor,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(color: kSecondaryColor),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              text,
                              style: GoogleFonts.cairo(
                                textStyle: kBodyLargeText.copyWith(
                                  fontSize: 22,
                                ),
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            'عدد التكرار: $repeats',
                            style: GoogleFonts.cairo(
                              textStyle: kBodyRegularText.copyWith(
                                color: kLightPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
