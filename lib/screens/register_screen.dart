import 'package:alhadiqa/circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.person_outlined, size: 35),
                  SizedBox(width: 10),
                  Text(
                    'إنشاء حساب جديد',
                    style: GoogleFonts.cairo(
                      textStyle: kHeading1Text.copyWith(fontSize: 25),
                    ),
                  ),
                ],
              ),
              Text(
                '! مرحبا بك في تطبيق الحديقة',
                style: GoogleFonts.cairo(textStyle: kBodyRegularText),
              ),
            ],
          ),
        ),
        leading: null,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: [
            CustomPaint(
              painter: CircleIntersectionPainter(),
              size: Size(400, 400), // Adjust size as needed
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 70),
                    Center(
                      child: Text(
                        'الحديقة',
                        style: GoogleFonts.elMessiri(
                          textStyle: kHeading1Text.copyWith(
                            color: kLightPrimaryColor,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    RoundedTextField(
                      obscure: false,
                      textColor: kPrimaryTextLight,
                      controller: emailController,
                      icon: Icons.person,
                      textHint: 'الايميل',
                      keyboardType: TextInputType.emailAddress,
                      hintColor: kPrimaryTextLight.withValues(
                        alpha: (0.199 * 255),
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(height: 50),
                    RoundedTextField(
                      obscure: true,
                      textColor: kPrimaryTextLight,
                      controller: passwordController,
                      textHint: 'كلمة المرور',
                      icon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      hintColor: kPrimaryTextLight.withValues(
                        alpha: (0.199 * 255),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(height: 50),
                    RoundedButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await _auth
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          if (user != null) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              HomeScreen.id,
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          print(e);
                          String errorMessage = 'حدث خطأ ما. حاول مرة اخرى';

                          if (e is FirebaseAuthException) {
                            if (e.code == 'weak-password') {
                              errorMessage = 'كلمة المرور ضعيفة';
                            } else if (e.code == 'email-already-in-use') {
                              errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
                            }
                          }
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(errorMessage)));
                        }
                        setState(() {
                          showSpinner = false;
                        });
                        emailController.clear();
                        passwordController.clear();
                      },
                      buttonText: 'إنشاء حساب',
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'هل لديك حساب من قبل ؟',
                        style: GoogleFonts.cairo(textStyle: kBodySmallText),
                      ),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                        emailController.clear();
                        passwordController.clear();
                      },
                      buttonText: 'تسجيل دخول',
                      isPrimary: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
