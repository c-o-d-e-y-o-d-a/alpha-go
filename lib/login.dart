import 'package:alpha_go/import_mnemonic.dart';
import 'package:alpha_go/generate_mnemonic.dart';
import 'package:alpha_go/legal_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EnterWalletMnemonic()),
                  );
                },
                child: Text("Import an Idenity")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LegalPage()),
                  );
                },
                child: Text("Generate an Identity"))
          ],
        ),
      ),
    );
  }
}
