import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/widgets/background_color.dart';
import 'package:alhadiqa/const.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundColor(),
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 300),
                  // Image.asset('images/example.jpeg', height: 100, width: 100),
                  SizedBox(height: 10),
                  Text('! مرحبا بكم في الحديقة', style: kHeading1TextDark),
                  SizedBox(height: 20),
                  Text(
                    'نسأل الله أن يحفظ القرآن في قلوبنا وأعمالنا',
                    style: kBodyRegularTextDark,
                  ),
                  SizedBox(height: 50),
                  RoundedButton(
                    route: LoginScreen.id,
                    buttonText: 'تسجيل دخول',
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    buttonText: 'إنشاء حساب جديد',
                    route: RegisterScreen.id,
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
