import 'dart:developer';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/const_model.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/screens/login_screen.dart';
import 'package:alpha_go/views/screens/wallet_created_screen.dart';
import 'package:alpha_go/views/screens/base_view.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen(
      {super.key, this.isImport = false, this.isEnter = false});
  final bool isImport;
  final bool isEnter;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final WalletController controller = Get.find();
  final UserController userController = Get.find();
  final SharedPreferences prefs = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/bg.jpg',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.h),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xffb4914b),
                  ),
                  height: 0.2.h,
                )),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text(
              widget.isEnter ? "Enter your Password" : "Set a Password",
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.isEnter
                    ? "Enter your wallet's password"
                    : "Set a password to secure your wallet."),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: TextField(
                    style: Constants.inputStyle,
                    controller: password,
                    decoration: Constants.inputDecoration.copyWith(
                      hintText: "Enter your Password",
                    ),
                    cursorColor: Colors.white,
                  ),
                ),
                widget.isEnter
                    ? Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: ElevatedButton(
                            style: Constants.buttonStyle,
                            onPressed: () async {
                              await prefs.remove('mnemonic');
                              await prefs.remove('password');
                              FirebaseAuth.instance.signOut();
                              Get.offAll(() => const LoginPage());
                            },
                            child: const Text('Logout')),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: TextField(
                          cursorColor: Colors.white,
                          style: Constants.inputStyle,
                          controller: confirmPassword,
                          decoration: Constants.inputDecoration
                              .copyWith(hintText: "Confirm your password"),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: ElevatedButton(
                    style: Constants.buttonStyle,
                    onPressed: () async {
                      final alphanumeric =
                          RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$');
                      log(alphanumeric.hasMatch(password.text).toString());
                      if (widget.isEnter) {
                        if (password.text == controller.password) {
                          await controller.createOrRestoreWallet(
                            Network.testnet,
                          );

                          await FirebaseUtils.users
                              .doc(controller.address)
                              .get()
                              .then((value) async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: "${controller.address}@alphago.com",
                                password: controller.password!,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                log('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                log('Wrong password provided for that user.');
                              } else {
                                log(e.toString());
                              }
                            }
                            Map<String, dynamic> data =
                                value.data() as Map<String, dynamic>;
                            userController.setUser(WalletUser(
                                accountName: data["accountName"]!,
                                walletAddress: data["walletAddress"]!,
                                bio: data["bio"]!,
                                pfpUrl: data["pfpUrl"]!));
                          });

                          Get.off(() => const NavBar());
                        } else {
                          Get.snackbar("Error",
                              "Password does not match, please use the password you set before",
                              colorText: Colors.white);
                        }
                        return;
                      } else if (password.text == confirmPassword.text) {
                        if (!alphanumeric.hasMatch(password.text)) {
                          Get.snackbar("Weak Password",
                              "Password must contain at least 1 uppercase letter, 1 number, and be at least 6 characters long",
                              colorText: Colors.white);
                          return;
                        } else {
                          controller.password = password.text;

                          Get.off(() => WalletCreatedScreen(
                                isImport: widget.isImport,
                              ));
                        }
                      }
                    },
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
