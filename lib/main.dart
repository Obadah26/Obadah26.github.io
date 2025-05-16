import 'package:alhadiqa/notification_service.dart';
import 'package:alhadiqa/screens/azkar_screen.dart';
import 'package:alhadiqa/screens/notification_screen.dart';
import 'package:alhadiqa/screens/user_detials_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:alhadiqa/screens/welcome_screen.dart';
import 'package:alhadiqa/screens/login_screen.dart';
import 'package:alhadiqa/screens/register_screen.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:alhadiqa/screens/menu_screen.dart';
import 'package:alhadiqa/screens/ijazah_recitation_screen.dart';
import 'package:alhadiqa/screens/daily_recitation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:alhadiqa/screens/ijazah_leaderboard.dart';
import 'package:alhadiqa/screens/recitation_leaderboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await initializeDateFormatting('ar', null);

  await NotificationService.initializeNotifications();

  // Set up notification listeners
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: NotificationService.onActionReceivedMethod,
    onNotificationDisplayedMethod:
        NotificationService.onNotificationDisplayedMethod,
  );
  final User? user = FirebaseAuth.instance.currentUser;

  final box = GetStorage();
  final bool rememberMe = box.read('rememberMe') ?? false;

  runApp(
    MyApp(
      initialRoute:
          (rememberMe && user != null) ? HomeScreen.id : WelcomeScreen.id,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        MenuScreen.id: (context) => const MenuScreen(),
        DailyRecitationScreen.id: (context) => const DailyRecitationScreen(),
        IjazahRecitationScreen.id: (context) => const IjazahRecitationScreen(),
        RecitationLeaderboardScreen.id:
            (context) => const RecitationLeaderboardScreen(),
        IjazahLeaderboardScreen.id:
            (context) => const IjazahLeaderboardScreen(),
        UserDetailsScreen.id: (context) => const UserDetailsScreen(),
        AzkarScreen.id: (context) => const AzkarScreen(),
        NotificationScreen.id: (context) => const NotificationScreen(),
      },
    );
  }
}
