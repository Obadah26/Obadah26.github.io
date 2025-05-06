import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/rounded_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF11F7A3), Color(0xFF216377)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  CircleAvatar(radius: 150, backgroundColor: Color(0xFF2F4858)),
                  SizedBox(height: 90),
                  Text(
                    '! مرحبا بكم في الحديقة',
                    style: TextStyle(
                      color: Color(0xFF2F4858),
                      fontSize: 28,
                      //fontFamily: 'Oi',
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(150, 31, 56, 72),
                          offset: Offset(2, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'نسال اللله حفظ القران',
                    style: TextStyle(
                      color: Color(0xFF2F4858),
                      fontSize: 30,
                      //fontFamily: 'Marhey',
                      //fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(150, 31, 56, 72),
                          offset: Offset(2, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 70),
                  RoundedButton(
                    route: LoginScreen.id,
                    buttonText: 'تسجيل دخول',
                    baseColor: Color(0xFF00C9B1),
                    reflectionColor: Color(0x4D4DFFEA),
                  ),
                  SizedBox(height: 20),
                  RoundedButton(
                    baseColor: Color(0xFF0FE8B8),
                    reflectionColor: Color(0x4D4DFFEA),
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
