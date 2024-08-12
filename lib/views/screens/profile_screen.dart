import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/views/screens/login_screen.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final WalletController controller = Get.find();
  final UserController userController = Get.find();
  final SharedPreferences prefs = Get.find();
  bool isFetchingBalance = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          IconButton(
              onPressed: () async {
                await prefs.remove('mnemonic');
                Get.offAll(LoginPage());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(userController.user.pfpUrl),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(userController.user.accountName),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(userController.user.walletAddress),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(userController.user.bio),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 110,
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_upward),
                                Text("SEND")
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 115,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isFetchingBalance = true;
                            });
                            await controller.getBalance().then((value) {
                              setState(() {
                                isFetchingBalance = false;
                              });
                            });
                          },
                          child: isFetchingBalance
                              ? const Center(child: CircularProgressIndicator())
                              : controller.balance == null
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.currency_bitcoin),
                                        Text("BALANCE")
                                      ],
                                    )
                                  : Text(
                                      "${controller.balance.toString()} Sats"),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.arrow_downward),
                                Text("RECIEVE")
                              ],
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        ButtonsTabBar(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          unselectedBackgroundColor:
                              Colors.grey.withOpacity(0.2),
                          borderWidth: 0,
                          borderColor: Colors.black,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: const [
                            Tab(
                              text: "INSCRIPTIONS",
                            ),
                            Tab(
                              text: "NFTS",
                            ),
                          ],
                        ),
                        const Expanded(
                          child: TabBarView(
                            children: <Widget>[Text("Tab1"), Text("Tab2")],
                            // Add your views here
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
