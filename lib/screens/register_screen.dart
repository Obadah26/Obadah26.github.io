import 'package:alhadiqa/circle_painter.dart';
import 'package:alhadiqa/lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/widgets/rounded_text_field.dart';
import 'package:alhadiqa/widgets/rounded_button.dart';
import 'package:alhadiqa/screens/login_screen.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userName = '';
  String email = '';
  String password = '';
  bool showSpinner = false;
  String? selectedUserName;
  List<String> availableUserNames = [];
  bool loadingUserNames = true;
  String? passwordError;
  String? emailError;
  String? userNameError;

  @override
  void initState() {
    super.initState();
    _loadAvailableUserNames();
  }

  Future<void> _loadAvailableUserNames() async {
    setState(() => loadingUserNames = true);

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('usernames').get();

      final takenNames = snapshot.docs.map((doc) => doc.id).toSet();

      setState(() {
        availableUserNames =
            userNames.where((name) => !takenNames.contains(name)).toList();
      });
    } catch (e) {
      setState(() => availableUserNames = List.from(userNames));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تعذر تحميل الأسماء المتاحة')));
    } finally {
      setState(() => loadingUserNames = false);
    }
  }

  Future<void> _registerUser() async {
    bool hasError = false;
    if (selectedUserName == null || selectedUserName!.isEmpty) {
      setState(() {
        userNameError = '◉ الرجاء اختيار اسم مستخدم.';
      });
      hasError = true;
    } else {
      userNameError = null;
    }

    if (email.trim().isEmpty) {
      setState(() {
        emailError = '◉ الرجاء إدخال البريد الإلكتروني.';
      });
      hasError = true;
    } else {
      emailError = null;
    }

    if (!_validatePassword(password)) {
      setState(() {
        passwordError = '◉ كلمة المرور يجب أن تكون 6 أحرف أو أكثر.';
      });
      hasError = true;
      return;
    } else {
      passwordError = null;
    }

    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ ما، يرجى تصحيح البيانات')),
      );
      return;
    }

    setState(() => showSpinner = true);

    try {
      final usernameDoc =
          await _firestore.collection('usernames').doc(selectedUserName).get();
      if (usernameDoc.exists) {
        throw FirebaseAuthException(
          code: 'username-taken',
          message: 'اسم المستخدم محجوز بالفعل',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateProfile(displayName: selectedUserName);
      await userCredential.user?.reload();
      await userCredential.user?.sendEmailVerification();

      final batch = _firestore.batch();
      batch.set(_firestore.collection('users').doc(userCredential.user!.uid), {
        'username': selectedUserName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
      });
      batch.set(_firestore.collection('usernames').doc(selectedUserName), {
        'userId': userCredential.user!.uid,
        'email': email,
        'reservedAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إنشاء الحساب بنجاح! يُرجى التحقق من بريدك الإلكتروني لتفعيل الحساب',
          ),
          duration: Duration(seconds: 5),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.id,
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'حدث خطأ أثناء التسجيل';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
      } else if (e.code == 'username-taken') {
        errorMessage = e.message ?? 'اسم المستخدم محجوز';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ غير متوقع: ${e.toString()}')),
      );
    } finally {
      setState(() => showSpinner = false);
    }
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

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
              size: Size(400, 400),
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
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: Container(
                        width: 370,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                userNameError != null
                                    ? Colors.redAccent
                                    : kLightPrimaryColor,
                            width: 1.5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: kLightPrimaryColor),
                            SizedBox(width: 8),
                            Expanded(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Center(
                                  child:
                                      loadingUserNames
                                          ? CircularProgressIndicator(
                                            strokeWidth: 2,
                                          )
                                          : availableUserNames.isEmpty
                                          ? Text(
                                            'لا توجد أسماء متاحة',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                          : Text('اختر اسم المستخدم'),
                                ),
                                value: selectedUserName,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: kLightPrimaryColor,
                                ),
                                iconSize: 24,
                                elevation: 4,
                                style: GoogleFonts.cairo(
                                  textStyle: kBodyRegularText.copyWith(),
                                ),
                                underline: Container(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedUserName = newValue!;
                                    userNameError = null;
                                  });
                                },
                                dropdownColor: Colors.white,
                                items:
                                    availableUserNames
                                        .map(
                                          (name) => DropdownMenuItem(
                                            value: name,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(name),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (userNameError != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            userNameError!,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    RoundedTextField(
                      obscure: false,
                      textColor: kPrimaryTextLight,
                      controller: emailController,
                      icon: Icons.mail,
                      textHint: 'الايميل',
                      keyboardType: TextInputType.emailAddress,
                      hintColor: kPrimaryTextLight.withValues(
                        alpha: (0.199 * 255),
                      ),
                      onChanged: (value) {
                        email = value;
                        if (emailError != null) {
                          setState(() => emailError = null);
                        }
                      },
                      hasError: emailError != null,
                    ),
                    if (emailError != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            emailError!,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
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
                      hasError: passwordError != null,
                    ),
                    if (passwordError != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            passwordError!,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 10,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),

                    SizedBox(height: 50),
                    RoundedButton(
                      onPressed: _registerUser,
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
