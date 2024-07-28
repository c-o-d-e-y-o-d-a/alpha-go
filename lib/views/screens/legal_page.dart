import 'package:alpha_go/views/screens/generate_mnemonic.dart';
import 'package:alpha_go/views/screens/import_mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key, this.isGenerate = true});
  final bool isGenerate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Legal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
                "Please review the Xverse Wallet Privacy Policy and Terms of Services,"),
            // SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Terms of Service"),
                      IconButton(
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Privacy Policy"),
                      IconButton(
                        icon: const Icon(Icons.link),
                        onPressed: () async {
                          final Uri url =
                              Uri.parse('https://alphaprotocol.network');
                          await launchUrl(url);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 50),
            const Text(
                "We would like to collect anonymous usage data to better understand users and improve the app. You can change this setting at any time."),
            // SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Authorise Data Collection"),
                RollingSwitch.icon(
                  onChanged: (bool state) {},
                  rollingInfoRight: const RollingIconInfo(
                    icon: Icons.flag,
                    text: Text('Yes'),
                  ),
                  rollingInfoLeft: const RollingIconInfo(
                    icon: Icons.check,
                    backgroundColor: Colors.grey,
                    text: Text('No'),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Get.to(() => isGenerate
                    ? const GenerateWalletMnemonic()
                    : const EnterWalletMnemonic());
              },
              child: const Text("Accept"),
            ),
          ],
        ),
      ),
    );
  }
}
