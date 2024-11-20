import 'dart:developer';

import 'package:alpha_go/models/wallet_model.dart';
import 'package:bdk_flutter/bdk_flutter.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  late Blockchain blockchain;
  BitcoinWallet? genWallet;
  String? password;
  String? mnemonic;
  String? address;
  int? balance;

  Future<void> generateMnemonicHandler() async {
    var res = await Mnemonic.create(WordCount.words12);
    mnemonic = res.toString();
  }

  Future<Blockchain> blockchainInit() async {
    blockchain = await Blockchain.create(
        config: BlockchainConfig.esplora(
            config: EsploraConfig(
      baseUrl: "https://blockstream.info/api/",
      stopGap: BigInt.from(5),
      concurrency: 1,
    )));
    // config: BlockchainConfig.electrum(
    //     config: ElectrumConfig(
    //         url: 'ssl://electrum.blockstream.info:60002',
    //         retry: 2,
    //         stopGap: BigInt.from(5),
    //         validateDomain: true)));
    return blockchain;
  }

  Future<List<Descriptor>> getDescriptors(String mnemonic) async {
    final descriptors = <Descriptor>[];
    try {
      for (var e in [KeychainKind.externalChain, KeychainKind.internalChain]) {
        final mnemonicObj = await Mnemonic.fromString(mnemonic);
        final descriptorSecretKey = await DescriptorSecretKey.create(
          network: Network.bitcoin,
          mnemonic: mnemonicObj,
        );
        final descriptor = await Descriptor.newBip84(
          secretKey: descriptorSecretKey,
          network: Network.bitcoin,
          keychain: e,
        );
        descriptors.add(descriptor);
      }
      return descriptors;
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> createOrRestoreWallet(
    Network network,
  ) async {
    try {
      final descriptors = await getDescriptors(mnemonic!);
      await blockchainInit();
      final res = await Wallet.create(
          descriptor: descriptors[0],
          changeDescriptor: descriptors[1],
          network: network,
          databaseConfig: const DatabaseConfig.memory());
      genWallet = BitcoinWallet(res);
      await getAddress();
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> getAddress() async {
    final addressInfo = genWallet!.wallet
        .getAddress(addressIndex: const AddressIndex.increase());
    address = addressInfo.address.toString();
  }

  Future<void> getBalance() async {
    await syncWallet();
    final balanceObj = genWallet!.wallet.getBalance();
    final res = "Total Balance: ${balanceObj.total.toString()}";
    log(res);
    balance = balanceObj.total.toInt();
  }

  Future<void> syncWallet() async {
    await genWallet!.wallet.sync(blockchain: blockchain);
  }

  Future<void> fetchTransanctions() async {
    // await syncWallet();
    List<LocalUtxo> unspentTokens = genWallet!.wallet.listUnspent();
    if (unspentTokens.isNotEmpty) {
      log(unspentTokens[0].outpoint.txid.toString());
    } else {
      log("No unspent tokens");
    }
  }
}
