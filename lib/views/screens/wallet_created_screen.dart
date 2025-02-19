import 'dart:developer';
import 'package:alpha_go/models/const_model.dart';
import 'package:alpha_go/views/screens/home_screen.dart';
import 'package:alpha_go/views/screens/onboarding.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletCreatedScreen extends StatefulWidget {
  const WalletCreatedScreen({super.key, required this.isImport});
  final bool isImport;
  @override
  State<WalletCreatedScreen> createState() => _WalletCreatedScreenState();
}

class _WalletCreatedScreenState extends State<WalletCreatedScreen> {
  bool isLoading = false;
  TextEditingController address = TextEditingController();
  TextEditingController balance = TextEditingController();
  final WalletController controller = Get.find();
  final SharedPreferencesWithCache prefs = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.createOrRestoreWallet().then((value) {
        setState(() {
          address.text = controller.address!;
        });
      });

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: "${controller.address!}@alphago.com",
          password: controller.password!,
        )
            .then((value) async {
          log("User has been Logged in");
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          log('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          log('The account already exists for that email.');
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "${controller.address}@alphago.com",
            password: controller.password!,
          );
        }
      } catch (e) {
        log("An error has occured ${e.toString()}");
      }

      await prefs.setString("mnemonic", controller.mnemonic!);
      await prefs.setString("password", controller.password!);
      log("prefs set", name: 'Shared Preferences');
      await controller.syncWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Wallet Created!"),
          bottom: Constants.appBarBottom,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.only(top: 5.h, left: 5.w, right: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      "Congratulations your wallet is ${widget.isImport ? "imported" : "created"}",
                      textAlign: TextAlign.center,
                    )),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: TextFormField(
                          readOnly: true,
                          controller: address,
                          style: Constants.inputStyle,
                          maxLines: 2,
                          decoration: Constants.inputDecoration.copyWith(
                              hintText: "Your Wallet Address",
                              suffixIconColor: const Color(0xffb4914b),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    if (controller.address != null) {
                                      await Clipboard.setData(ClipboardData(
                                              text: controller.address!))
                                          .then((onCallback) {
                                        Get.snackbar('Copy Successfull',
                                            'Your Wallet Address has been copied to your clipboard',
                                            colorText: Colors.white);
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                  )))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: ElevatedButton(
                        style: Constants.buttonStyle,
                        onPressed: () {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Get.off(const OnboardingScreen());
                          }
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
