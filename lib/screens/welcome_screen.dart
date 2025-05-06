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
                  SizedBox(height: 50),
                  CircleAvatar(radius: 150, backgroundColor: Color(0xFF119DA4)),
                  SizedBox(height: 90),
                  Text('! مرحبا بكم في الحديقة', style: kHeading1Text),
                  SizedBox(height: 20),
                  Text('نسال اللله حفظ القران', style: kHeading2Text),
                  SizedBox(height: 70),
                  RoundedButton(
                    route: LoginScreen.id,
                    buttonText: 'تسجيل دخول',
                    isPrimary: true,
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    isPrimary: false,
                    buttonText: 'إنشاء حساب جديد',
                    route: RegisterScreen.id,
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
