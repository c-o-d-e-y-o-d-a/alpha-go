import 'package:alpha_go/wallet_created.dart';
import 'package:flutter/material.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen(
      {super.key, required this.mnemonic, this.isImport = false});
  final String mnemonic;
  final bool isImport;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Set a Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Set a password to secure your wallet."),
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
                onPressed: () {
                  if (password.text == confirmPassword.text) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WalletCreatedScreen(
                                mnemonic: widget.mnemonic,
                                password: password.text,
                                isImport: widget.isImport,
                              )),
                    );
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ));
  }
}
