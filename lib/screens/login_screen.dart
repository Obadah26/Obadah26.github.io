import 'package:alhadiqa/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/rounded_text_field.dart';
import 'package:alhadiqa/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

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
                    'تسجيل دخول',
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
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'تذكرني',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2F4858),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: Color(0xFF216377),
                        checkColor: Color(0xFF11F7A3),
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                RoundedButton(
                  route: LoginScreen.id,
                  buttonText: 'تسجيل دخول',
                  baseColor: Color(0xFF0FE8B8),
                  reflectionColor: Color(0x4D4DFFEA),
                ),
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'او',
                    style: TextStyle(
                      color: Color(0xFF2F4858),
                      fontSize: 30,
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
                SizedBox(height: 40),
                RoundedButton(
                  route: RegisterScreen.id,
                  buttonText: 'إنشاء حساب جديد',
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
