import 'package:alpha_go/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  late WalletUser user;

  void setUser(WalletUser newUser) {
    user = newUser;
  }

  Map<String, dynamic> toJson() {
    return {
      'pfpUrl': user.pfpUrl,
      'walletAddress': user.walletAddress,
      'accountName': user.accountName,
      'bio': user.bio,
    };
  }
}
