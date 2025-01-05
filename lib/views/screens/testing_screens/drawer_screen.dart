import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/views/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletController controller = Get.find();
    final UserController userController = Get.find();
    return Scaffold(

      appBar: AppBar(
        title: const Text('Drawer Screen'),
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text('Welcome to the Drawer Screen!'),
      ),
    );
  }
}
