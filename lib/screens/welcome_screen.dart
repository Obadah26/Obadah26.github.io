import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/const.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -200,
            left: -200,
            child: Container(
              width: 500,
              height: 475,
              decoration: BoxDecoration(
                color: Color(0xffcce3ea),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 325,
              decoration: BoxDecoration(
                color: Color(0xffa3cdd9),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 300),
                  // Image.asset('images/example.jpeg', height: 100, width: 100),
                  SizedBox(height: 10),
                  Text('! مرحبا بكم في الحديقة', style: kHeading1Text),
                  SizedBox(height: 20),
                  Text(
                    'نسأل الله أن يحفظ القرآن في قلوبنا وأعمالنا',
                    style: kBodyRegularText,
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
