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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 600; // Web detection

          return Stack(
            children: [
              Visibility(
                visible: isWeb ? false : true,
                child: CustomPaint(
                  painter: CircleIntersectionPainter(),
                  size: Size(400, 400),
                ),
              ),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWeb ? 40 : 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          'images/welcome_image.png',
                          width: isWeb ? 300 : double.infinity,
                        ),
                        SizedBox(height: 30),
                        Text.rich(
                          TextSpan(
                            text: '! مرحبا بكم في ',
                            style: GoogleFonts.elMessiri(
                              textStyle: kHeading1Text.copyWith(
                                fontSize: isWeb ? 30 : 20,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: 'الحديقة',
                                style: GoogleFonts.elMessiri(
                                  textStyle: kHeading1Text.copyWith(
                                    color: kLightPrimaryColor,
                                    fontSize: isWeb ? 35 : 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'نسأل الله أن يحفظ القرآن في قلوبنا وأعمالنا',
                          style: GoogleFonts.cairo(
                            textStyle: kBodyRegularText.copyWith(
                              fontSize: isWeb ? 18 : 14,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isWeb ? 60 : 50),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
