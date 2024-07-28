import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final WalletController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Account 1"),
                  SizedBox(
                    height: 20,
                  ),
                  Text(controller.address!),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Vero sit dolor sed gubergren diam duo elitr, erat consetetur at duo ut et dolores. Amet dolor ipsum gubergren rebum."),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Column(
                              children: [
                                Icon(Icons.arrow_upward),
                                Text("SEND")
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Column(
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
          Divider(
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
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(
                              text: "INSCRIPTIONS",
                            ),
                            Tab(
                              text: "NFTS",
                            ),
                          ],
                        ),
                        Expanded(
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
