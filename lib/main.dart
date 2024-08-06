import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:alpha_go/views/screens/login_screen.dart';
import 'package:alpha_go/views/screens/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs =
      Get.put(await SharedPreferences.getInstance());
  final WalletController controller = Get.put(WalletController());
  Get.put(UserController());
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
    return GetMaterialApp(
      title: 'Alpha Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initWidget,
      // home: MapHomePage(),
    );
  }
}
