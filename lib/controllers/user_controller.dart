import 'package:alpha_go/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  WalletUser user = WalletUser(
    pfpUrl: '',
    walletAddress: '',
    accountName: '',
    bio: '',
  );

  void setUser(WalletUser newUser) {
    user = newUser;
  }

  void updatePfpUrl(String newPfpUrl) {
    user.pfpUrl = newPfpUrl;
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
