import 'dart:developer';

import 'package:alpha_go/models/const_model.dart';
import 'package:alpha_go/views/screens/generate_mnemonic_screen.dart';
import 'package:alpha_go/views/screens/import_mnemonic_screen.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({super.key, required this.isGenerate});
  final bool isGenerate;

  @override
  State<LegalPage> createState() => LegalPageState();
}

class LegalPageState extends State<LegalPage> {
  bool isAuthorised = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffb4914b),
                ),
                height: 0.2.h,
              )),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: const Text(
            "Legal",
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 5.h, right: 5.w, left: 5.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: const Text(
                      "Please review the Alpha Protocol Wallet Privacy Policy and Terms of Services,"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Terms of Service"),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.link),
                      onPressed: () async {
                        final Uri url =
                            Uri.parse('https://alphaprotocol.network');
                        await launchUrl(url);
                      },
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                  color: Color(0xffb4914b),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Privacy Policy"),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.link),
                      onPressed: () async {
                        final Uri url =
                            Uri.parse('https://alphaprotocol.network');
                        await launchUrl(url);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: const Text(
                      "We would like to collect anonymous usage data to better understand users and improve the app. You can change this setting at any time."),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Authorise Data Collection"),
                      SizedBox(
                        height: 4.h,
                        width: 20.w,
                        child: AnimatedToggleSwitch<bool>.dual(
                          current: isAuthorised,
                          first: false,
                          second: true,
                          fittingMode: FittingMode.preventHorizontalOverlapping,
                          onChanged: (bool value) => setState(() {
                            log(value.toString());
                            isAuthorised = value;
                          }),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4.h),
                  width: 50.w,
                  height: 10.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => widget.isGenerate
                          ? const GenerateWalletMnemonic()
                          : const EnterWalletMnemonic());
                    },
                    style: Constants.buttonStyle,
                    child: Text(
                      "Accept",
                      style: TextStyle(
                          fontFamily: 'Cinzel',
                          color: Colors.white,
                          fontSize: 20.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
