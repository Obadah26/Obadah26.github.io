import 'package:flutter/material.dart';
import 'package:alhadiqa/rounded_text_field.dart';
import 'package:alhadiqa/rounded_button.dart';
import 'package:alhadiqa/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            child: Column(
              children: [
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      color: Color(0xFF2F4858),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(77, 216, 216, 216),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                RoundedTextField(
                  icon: Icons.person,
                  textHint: 'name@email.com',
                ),
                SizedBox(height: 50),
                RoundedTextField(textHint: 'password', icon: Icons.lock),
                SizedBox(height: 40),
                RoundedButton(
                  route: RegisterScreen.id,
                  buttonText: 'إنشاء حساب',
                  baseColor: Color(0xFF0FE8B8),
                  reflectionColor: Color(0x4D4DFFEA),
                ),
                SizedBox(height: 50),
                Center(
                  child: Text(
                    'هل لديك حساب من قبل؟',
                    style: TextStyle(
                      color: Color(0xFF2F4858),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(77, 216, 216, 216),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                RoundedButton(
                  route: LoginScreen.id,
                  buttonText: 'تسجيل دخول',
                  baseColor: Color(0xFF0FE8B8),
                  reflectionColor: Color(0x4D4DFFEA),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
