class WalletUser {
  String pfpUrl;
  final String walletAddress;
  final String accountName;
  final String bio;

  WalletUser({
    required this.pfpUrl,
    required this.walletAddress,
    required this.accountName,
    required this.bio,
  });

  WalletUser.fromMap(Map<String, dynamic> map)
      : pfpUrl = map['pfpUrl'],
        walletAddress = map['walletAddress'],
        accountName = map['accountName'],
        bio = map['bio'];

  Map<String, dynamic> toJson() {
    return {
      'pfpUrl': pfpUrl,
      'walletAddress': walletAddress,
      'accountName': accountName,
      'bio': bio,
    };
  }
}
