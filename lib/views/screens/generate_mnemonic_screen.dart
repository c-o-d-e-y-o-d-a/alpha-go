import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/views/screens/set_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenerateWalletMnemonic extends StatefulWidget {
  const GenerateWalletMnemonic({super.key});

  @override
  State<GenerateWalletMnemonic> createState() => _GenerateWalletMnemonicState();
}

class _GenerateWalletMnemonicState extends State<GenerateWalletMnemonic> {
  final TextEditingController mnemonic = TextEditingController();
  final WalletController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.generateMnemonicHandler().then((value) {
      setState(() {
        mnemonic.text = controller.mnemonic!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup your Seed Phrase"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
              "Write down your seed phrase and make sure to keep it private. This is the unique key to your wallet."),
          TextFormField(
              readOnly: true,
              controller: mnemonic,
              //keyboardType: TextInputType.multiline,
              maxLines: 2,
              decoration:
                  const InputDecoration(hintText: "Enter your mnemonic")),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const SetPasswordScreen());
              },
              child: const Text("Continue")),
        ],
      ),
    );
  }
}
