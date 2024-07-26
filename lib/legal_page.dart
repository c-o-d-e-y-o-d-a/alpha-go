import 'package:alpha_go/generate_mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:rolling_switch/rolling_switch.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Legal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                "Please review the Xverse Wallet Privacy Policy and Terms of Services,"),
            // SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Terms of Service"),
                      Icon(Icons.link),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Privacy Policy"),
                      Icon(Icons.link),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 50),
            Text(
                "We would like to collect anonymous usage data to better understand users and improve the app. You can change this setting at any time."),
            // SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Authorise Data Collection"),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GenerateWalletMnemonic()),
                );
              },
              child: Text("Accept"),
            ),
          ],
        ),
      ),
    );
  }
}
