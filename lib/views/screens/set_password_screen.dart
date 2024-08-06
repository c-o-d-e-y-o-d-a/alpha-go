import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/screens/wallet_created_screen.dart';
import 'package:alpha_go/views/widgets/navbar.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
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
                  if (password.text == confirmPassword.text) {
                    if (widget.isEnter) {
                      if (password.text == controller.password) {
                        await controller.createOrRestoreWallet(
                          Network.Testnet,
                        );
                        await FirebaseUtils.users
                            .doc(controller.address)
                            .get()
                            .then((value) {
                          Map<String, dynamic> data =
                              value.data() as Map<String, dynamic>;
                          userController.setUser(User(
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
                    controller.password = password.text;
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
