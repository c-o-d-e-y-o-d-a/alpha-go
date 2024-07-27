import 'dart:developer';

import 'package:alpha_go/set_password.dart';
import 'package:alpha_go/widgets.dart';
import 'package:flutter/material.dart';

class EnterWalletMnemonic extends StatefulWidget {
  const EnterWalletMnemonic({super.key});

  @override
  State<EnterWalletMnemonic> createState() => _EnterWalletMnemonicState();
}

class _EnterWalletMnemonicState extends State<EnterWalletMnemonic> {
  TextEditingController mnemonic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your Seed Phrase"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
              "Enter your wallet's private Seed Phrase with Spaces between each phrase. This is the unique key to your wallet."),
          TextFieldContainer(
            child: TextFormField(
                controller: mnemonic,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration:
                    const InputDecoration(hintText: "Enter your mnemonic")),
          ),
          ElevatedButton(
              onPressed: () {
                log(mnemonic.text);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SetPasswordScreen(
                            mnemonic: mnemonic.text,
                            isImport: true,
                          )),
                );
              },
              child: const Text("Continue")),
        ],
      ),
    );
  }
}
