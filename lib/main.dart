import 'package:alpha_go/controllers/event_controller.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:alpha_go/views/screens/login_screen.dart';
import 'package:alpha_go/views/screens/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs =
      Get.put(await SharedPreferences.getInstance());
  final WalletController controller = Get.put(WalletController());
  Get.put(UserController());
  final EventController eventController = Get.put(EventController());
  await eventController.getEvents();
  if (prefs.containsKey("mnemonic") && prefs.getString("mnemonic") != null) {
    controller.mnemonic = prefs.getString("mnemonic")!;
    controller.password = prefs.getString("password")!;
    runApp(const MyApp(
        initWidget: SetPasswordScreen(
      isEnter: true,
    )));
  } else {
    runApp(const MyApp(initWidget: LoginPage()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initWidget});
  final Widget initWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        title: 'Alpha Go',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(
            displayLarge: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 57,
                fontWeight: FontWeight.bold),
            displayMedium: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 45,
                fontWeight: FontWeight.bold),
            displaySmall: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 36,
                fontWeight: FontWeight.bold),
            headlineLarge: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 32,
                fontWeight: FontWeight.bold),
            headlineMedium: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 28,
                fontWeight: FontWeight.bold),
            headlineSmall: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 24,
                fontWeight: FontWeight.bold),
            titleLarge: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 22,
                fontWeight: FontWeight.w900),
            titleMedium: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 16,
                fontWeight: FontWeight.w900),
            titleSmall: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 14,
                fontWeight: FontWeight.w500),
            bodyLarge: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 16,
                fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(
                color: Colors.white,
                fontFamily: 'Cinzel',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
            bodySmall: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 12,
                fontWeight: FontWeight.w400),
            labelLarge: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 14,
                fontWeight: FontWeight.w500),
            labelMedium: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 12,
                fontWeight: FontWeight.w400),
            labelSmall: const TextStyle(
                fontFamily: 'Cinzel',
                fontSize: 11,
                fontWeight: FontWeight.w400),
          ),
        ),
        home: initWidget,
      );
    });
  }
}
