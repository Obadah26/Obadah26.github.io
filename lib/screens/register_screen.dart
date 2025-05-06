import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/widgets/background_color.dart';
import 'package:alhadiqa/const.dart';

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
          BackgroundColor(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(child: Text('إنشاء حساب', style: kHeading1Text)),
                  SizedBox(height: 50),
                  RoundedTextField(
                    icon: Icons.person,
                    textHint: 'name@email.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 50),
                  RoundedTextField(
                    textHint: 'password',
                    icon: Icons.lock,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 40),
                  RoundedButton(
                    route: HomeScreen.id,
                    buttonText: 'إنشاء حساب',
                    isPrimary: true,
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: Text('هل لديك حساب من قبل؟', style: kHeading2Text),
                  ),
                  SizedBox(height: 50),
                  RoundedButton(
                    route: LoginScreen.id,
                    buttonText: 'تسجيل دخول',
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
