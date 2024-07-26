import 'package:alpha_go/set_password.dart';
import 'package:alpha_go/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/widgets.dart';

class GenerateWalletMnemonic extends StatefulWidget {
  const GenerateWalletMnemonic({super.key});

  @override
  State<GenerateWalletMnemonic> createState() => _GenerateWalletMnemonicState();
}

class _GenerateWalletMnemonicState extends State<GenerateWalletMnemonic> {
  TextEditingController mnemonic = TextEditingController();

  Future<void> generateMnemonicHandler() async {
    var res = await Mnemonic.create(WordCount.Words12);
    setState(() {
      mnemonic.text = res.asString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateMnemonicHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup your Seed Phrase"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
              "Write down your seed phrase and make sure to keep it private. This is the unique key to your wallet."),
          TextFieldContainer(
            child: TextFormField(
                readOnly: true,
                controller: mnemonic,
                //keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration:
                    const InputDecoration(hintText: "Enter your mnemonic")),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SetPasswordScreen(
                            mnemonic: mnemonic.text,
                          )),
                );
              },
              child: Text("Continue")),
        ],
      ),
    );
  }
}
