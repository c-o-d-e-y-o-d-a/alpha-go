import 'dart:developer';

import 'package:alpha_go/homepage.dart';
import 'package:alpha_go/wallet_balance.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:flutter/material.dart';

class WalletCreatedScreen extends StatefulWidget {
  const WalletCreatedScreen(
      {super.key,
      required this.mnemonic,
      required this.password,
      required this.isImport});
  final String mnemonic;
  final String password;
  final bool isImport;
  @override
  State<WalletCreatedScreen> createState() => _WalletCreatedScreenState();
}

class _WalletCreatedScreenState extends State<WalletCreatedScreen> {
  TextEditingController address = TextEditingController();
  TextEditingController balance = TextEditingController();
  late Wallet wallet;
  late Blockchain blockchain;

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

  Future<List<Descriptor>> getDescriptors(String mnemonic) async {
    final descriptors = <Descriptor>[];
    try {
      for (var e in [KeychainKind.External, KeychainKind.Internal]) {
        final mnemonicObj = await Mnemonic.fromString(mnemonic);
        final descriptorSecretKey = await DescriptorSecretKey.create(
          network: Network.Testnet,
          mnemonic: mnemonicObj,
        );
        final descriptor = await Descriptor.newBip84(
          secretKey: descriptorSecretKey,
          network: Network.Testnet,
          keychain: e,
        );
        descriptors.add(descriptor);
      }
      return descriptors;
    } on Exception catch (e) {
      setState(() {
        address.text = "Error : ${e.toString()}";
      });
      rethrow;
    }
  }

  Future<void> blockchainInit() async {
    blockchain = await Blockchain.create(
        config: BlockchainConfig.esplora(
            config: EsploraConfig(
      baseUrl: "https://blockstream.info/testnet/api",
      stopGap: 5,
      concurrency: 2,
    )));
  }

  Future<void> createOrRestoreWallet(
      String mnemonic, Network network, String? password) async {
    try {
      final descriptors = await getDescriptors(mnemonic);
      await blockchainInit();
      final res = await Wallet.create(
          descriptor: descriptors[0],
          changeDescriptor: descriptors[1],
          network: network,
          databaseConfig: const DatabaseConfig.memory());
      var addressInfo =
          await res.getAddress(addressIndex: const AddressIndex());
      setState(() {
        address.text = addressInfo.address;
        wallet = res;
        // displayText = "Wallet Created: $address";
      });
    } on Exception catch (e) {
      setState(() {
        address.text = "Error: ${e.toString()}";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createOrRestoreWallet(widget.mnemonic, Network.Testnet, widget.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
              child: Text("Congratulations your wallet is " +
                  (widget.isImport ? "imported" : "created"))),
          TextFormField(
              readOnly: true,
              controller: address,
              maxLines: 5,
              decoration:
                  const InputDecoration(hintText: "Enter your mnemonic")),
          Center(
            child: TextFormField(
                controller: balance,
                readOnly: true,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration:
                    const InputDecoration(hintText: "Enter your mnemonic")),
          ),
          ElevatedButton(
            onPressed: () async {
              await syncWallet();
              await getBalance();
              log("Refreshed");
            },
            child: Text("Refresh"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MapHomePage()),
              );
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
