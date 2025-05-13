import 'package:alhadiqa/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alhadiqa/screens/login_screen.dart';

class VerificationCheckScreen extends StatefulWidget {
  static String id = 'verification_check_screen';

  const VerificationCheckScreen({super.key});

  @override
  State<VerificationCheckScreen> createState() =>
      _VerificationCheckScreenState();
}

class _VerificationCheckScreenState extends State<VerificationCheckScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isVerified = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        _isVerified = user.emailVerified;
        _isLoading = false;
      });

      if (_isVerified) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.id,
          (route) => false,
        );
      }
    }
  }

  Future<void> _resendVerification() async {
    setState(() => _isLoading = true);
    try {
      await _auth.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم إعادة إرسال رابط التحقق')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إعادة الإرسال')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isLoading
                ? CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'الرجاء التحقق من بريدك الإلكتروني',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'لقد أرسلنا رابط تحقق إلى ${_auth.currentUser?.email}',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _resendVerification,
                      child: Text('إعادة إرسال رابط التحقق'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginScreen.id,
                          (route) => false,
                        );
                      },
                      child: Text('تسجيل الدخول بحساب آخر'),
                    ),
                  ],
                ),
      ),
    );
  }
}
