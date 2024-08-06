import 'dart:developer';

import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/widgets/navbar.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final UserController userController = Get.find();
  final SharedPreferences prefs = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller
          .createOrRestoreWallet(
        Network.Testnet,
      )
          .then((value) {
        setState(() {
          address.text = controller.address!;
        });
      });
      await controller.syncWallet();
      await prefs.setString("mnemonic", controller.mnemonic!);
      await prefs.setString("password", controller.password!);
      userController.setUser(User(
          pfpUrl: "",
          walletAddress: controller.address!,
          accountName: "Account 1",
          bio: "BIO"));
      await FirebaseUtils.users
          .doc(controller.address)
          .set(userController.toJson());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                          "Congratulations your wallet is ${widget.isImport ? "imported" : "created"}")),
                  TextFormField(
                      readOnly: true,
                      controller: address,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: "Wallet Address Loading")),
                  Center(
                    child: TextFormField(
                        controller: balance,
                        readOnly: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: const InputDecoration(
                            hintText:
                                "Please Refresh to fetch wallet balance")),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await controller.syncWallet();
                      await controller.getBalance().then((value) {
                        balance.text = "${controller.balance.toString()} Sats";
                      });
                      setState(() {
                        isLoading = false;
                      });
                      log("Refreshed");
                    },
                    child: const Text("Refresh"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const NavBar());
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
      ),
    );
  }
}
