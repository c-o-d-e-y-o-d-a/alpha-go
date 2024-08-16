import 'dart:developer';
import 'package:alpha_go/views/screens/onboarding.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/screens/wallet_created_screen.dart';
import 'package:alpha_go/views/widgets/navbar.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(widget.isEnter ? "Enter your Password" : "Set a Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.isEnter
                  ? "Enter your wallet's password"
                  : "Set a password to secure your wallet."),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  hintText: "Enter your password",
                ),
              ),
              TextField(
                controller: confirmPassword,
                decoration: const InputDecoration(
                  hintText: "Confirm your password",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final alphanumeric =
                      RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$');
                  log(alphanumeric.hasMatch(password.text).toString());
                  if (password.text == confirmPassword.text) {
                    if (widget.isEnter) {
                      if (password.text == controller.password) {
                        await controller.createOrRestoreWallet(
                          Network.Testnet,
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

                        Get.to(() => const NavBar());
                      } else {
                        Get.snackbar("Error", "Password does not match");
                      }
                      return;
                    }
                    if (!alphanumeric.hasMatch(password.text)) {
                      Get.snackbar("Weak Password",
                          "Password must contain at least 1 uppercase letter, 1 number, and be at least 6 characters long");
                      return;
                    }
                    controller.password = password.text;
                    try {
                      final credential = await FirebaseAuth.instance
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
                      log(e.toString());
                    }
                    //Get.to(OnboardingScreen());
                    Get.to(() => WalletCreatedScreen(
                          isImport: widget.isImport,
                        ));
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ));
  }
}
