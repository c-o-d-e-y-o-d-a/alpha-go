
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/const_model.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // shape: RoundedRectangleBorder(
          //     side: const BorderSide(color: Color(0xffb4914b)),
          //     borderRadius:
          //         BorderRadius.vertical(bottom: Radius.circular(20.sp))),
          bottom: Constants.appBarBottom,
          leading: Padding(
            padding: EdgeInsets.only(
              left: 3.w,
            ),
            child: const Icon(
              Icons.alternate_email,
            ),
          ),
          title: Text(
            controller.address!,
          ),
          leadingWidth: 9.w,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          foregroundColor: const Color(0xffb4914b),
          actions: [
            IconButton(
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: controller.address!));
                  Get.snackbar(
                      'Copy Successful', 'Wallet Address copied to clipboard',
                      colorText: Colors.white);
                },
                icon: Icon(
                  Icons.copy,
                  size: 24.sp,
                )),
            IconButton(
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: controller.address!));
                  Get.snackbar(
                      'Copy Successful', 'Wallet Address copied to clipboard',
                      colorText: Colors.white);
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  size: 24.sp,
                )),
            IconButton(
                onPressed: () async {},
                icon: Icon(
                  Icons.menu,
                  size: 26.sp,
                ))
          ],
        ),
        body: Padding(
          padding:
              EdgeInsets.only(left: 1.w, right: 1.w, top: 1.h, bottom: 1.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: const Color(0xffb4914b)),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 2.h, left: 1.w, right: 1.w, bottom: 2.h),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(userController.user.pfpUrl ?? ""),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                              userController.user.accountName,
                              style: TextStyle(
                                  color: const Color(0xffb4914b),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(userController.user.bio),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 29.w,
                                height: 70,
                                child: ElevatedButton(
                                    style: Constants.buttonStyle,
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.arrow_upward,
                                          color: Color(0xffb4914b),
                                        ),
                                        Text(
                                          "SEND",
                                          style: TextStyle(
                                            color: const Color(0xffb4914b),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: 29.w,
                                height: 70,
                                child: ElevatedButton(
                                  style: Constants.buttonStyle,
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
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : controller.balance == null
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.currency_bitcoin,
                                                  color: Color(0xffb4914b),
                                                ),
                                                Text(
                                                  "BALANCE",
                                                  style: TextStyle(
                                                    color: const Color(0xffb4914b),
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            )
                                          : Text(
                                              "${controller.balance.toString()} Sats",
                                              style: TextStyle(
                                                color: const Color(0xffb4914b),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                ),
                              ),
                              SizedBox(
                                width: 29.w,
                                height: 70,
                                child: ElevatedButton(
                                    style: Constants.buttonStyle,
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(
                                          Icons.arrow_downward,
                                          color: Color(0xffb4914b),
                                        ),
                                        Text(
                                          "RECIEVE",
                                          style: TextStyle(
                                            color: const Color(0xffb4914b),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0.5.h,
                    right: 2.w,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.ios_share_sharp,
                            ))
                      ],
                    ))
              ],
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: const Color(0xffb4914b)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: <Widget>[
                          ButtonsTabBar(
                            backgroundColor: Colors.transparent,
                            unselectedBackgroundColor: Colors.transparent,
                            contentPadding: EdgeInsets.only(
                                top: 1.h, left: 5.w, right: 5.w),
                            borderWidth: 0,
                            labelStyle: const TextStyle(
                              fontFamily: 'Cinzel',
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    color: Color(0xffb4914b),
                                    offset: Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xffb4914b),
                              decorationThickness: 4,
                              decorationStyle: TextDecorationStyle.solid,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w100,
                              color: const Color(0xffb4914b),
                            ),
                            tabs: const [
                              Tab(
                                text: "TIMELINE",
                              ),
                              Tab(
                                text: "TOKENS",
                              ),
                              Tab(
                                text: "NFTS",
                              )
                            ],
                          ),
                          const Expanded(
                            child: TabBarView(
                              children: <Widget>[
                                Text("Tab1"),
                                Text("Tab2"),
                                Text('Tab3')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          ]),
        ),
      ),
    );
  }
}
