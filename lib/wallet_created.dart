import 'dart:developer';

import 'package:alpha_go/homepage.dart';
import 'package:alpha_go/navbar.dart';
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
  bool isLoading = false;
  TextEditingController address = TextEditingController();
  TextEditingController balance = TextEditingController();
  late Wallet wallet;
  late Blockchain blockchain;

  Future<void> getBalance() async {
    final balanceObj = await wallet.getBalance();
    final res = "Total Balance: ${balanceObj.total.toString()}";
    log(res);
    setState(() {
      balance.text = "${balanceObj.total} Sats";
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
        config: const BlockchainConfig.esplora(
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
        address.text = "Your Wallet Address is: ${addressInfo.address}";
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
    super.initState();
    createOrRestoreWallet(widget.mnemonic, Network.Testnet, widget.password);
    syncWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
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
                      //  await syncWallet();
                      await getBalance();
                      setState(() {
                        isLoading = false;
                      });
                      log("Refreshed");
                    },
                    child: const Text("Refresh"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NavBar()),
                      );
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
      ),
    );
  }
}
