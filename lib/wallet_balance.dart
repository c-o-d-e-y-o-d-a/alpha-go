import 'dart:developer';

import 'package:alpha_go/widgets.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/material.dart';

class WalletBalanceScreen extends StatefulWidget {
  const WalletBalanceScreen({super.key, required this.wallet});
  final Wallet wallet;

  @override
  State<WalletBalanceScreen> createState() => _WalletBalanceScreenState();
}

class _WalletBalanceScreenState extends State<WalletBalanceScreen> {
  late Blockchain blockchain;
  TextEditingController balance = TextEditingController();
  late Wallet wallet;

  Future<void> getBalance() async {
    final balanceObj = await wallet.getBalance();
    final res = "Total Balance: ${balanceObj.total.toString()}";
    log(res);
    setState(() {
      balance.text = balanceObj.total.toString();
    });
  }

  Future<void> syncWallet() async {
    wallet.sync(blockchain);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      wallet = widget.wallet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: TextFieldContainer(
              child: TextFormField(
                  controller: balance,
                  readOnly: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(hintText: "Enter your mnemonic")),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  balance.text = "Refreshing...";
                });
                await syncWallet();
                await getBalance();
                log("Refreshed");
              },
              child: const Text("Refresh")),
        ],
      ),
    );
  }
}
