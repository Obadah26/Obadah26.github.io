import 'package:alhadiqa/circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/const.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomPaint(
            painter: CircleIntersectionPainter(),
            size: Size(400, 400),
          ),
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Image.asset('images/example2.png'),
                  Text.rich(
                    TextSpan(
                      text: '! مرحبا بكم في ',
                      style: GoogleFonts.elMessiri(
                        textStyle: kHeading1Text.copyWith(fontSize: 20),
                      ),
                      children: [
                        TextSpan(
                          text: 'الحديقة',
                          style: GoogleFonts.elMessiri(
                            textStyle: kHeading1Text.copyWith(
                              color: kLightPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'نسأل الله أن يحفظ القرآن في قلوبنا وأعمالنا',
                    style: GoogleFonts.cairo(textStyle: kBodyRegularText),
                  ),
                  SizedBox(height: 50),
                  RoundedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    buttonText: 'تسجيل دخول',
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    buttonText: 'إنشاء حساب جديد',
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                    isPrimary: false,
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
