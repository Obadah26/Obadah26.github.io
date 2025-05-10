import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class IjazahRecitationScreen extends StatefulWidget {
  const IjazahRecitationScreen({super.key});
  static String id = 'ijazah_recitation_screen';

  @override
  State<IjazahRecitationScreen> createState() => _IjazahRecitationScreenState();
}

class _IjazahRecitationScreenState extends State<IjazahRecitationScreen> {
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
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      'تسميع الاجازة',
                      style: GoogleFonts.elMessiri(textStyle: kHeading2Text),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ':',
                        style: GoogleFonts.cairo(
                          textStyle: kBodyRegularText.copyWith(fontSize: 20),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'اضافة تسميع',
                          style: GoogleFonts.cairo(
                            textStyle: kBodyRegularText.copyWith(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedTextField(
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
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'من صفحة',
                          style: GoogleFonts.cairo(
                            textStyle: kBodyRegularText.copyWith(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RoundedTextField(
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
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'الى صفحة',
                          style: GoogleFonts.cairo(
                            textStyle: kBodyRegularText.copyWith(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: RoundedButton(
                      buttonText: 'حفظ',
                      isPrimary: false,
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(height: 300),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
