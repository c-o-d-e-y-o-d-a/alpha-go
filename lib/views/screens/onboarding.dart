import 'dart:developer';
import 'dart:io';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isUploading = false;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  final storageRef = FirebaseStorage.instance.ref();
  final WalletController controller = Get.find();
  final UserController userController = Get.find();
  final ImagePicker picker = ImagePicker();
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 70,
            foregroundImage:
                !isUploading ? NetworkImage(user.photoURL ?? "") : null,
            child: isUploading ? const CircularProgressIndicator() : null,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isUploading = true;
              });
              final mountainsRef =
                  storageRef.child('${controller.address}.jpg');
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                File file = File(image.path);
                try {
                  await mountainsRef.putFile(file).then((value) async {
                    await mountainsRef.getDownloadURL().then((value) async {
                      await user.updatePhotoURL(value);
                      setState(() {});
                    });
                  });
                } on FirebaseException catch (e) {
                  log(e.toString());
                }
                setState(() {
                  isUploading = false;
                });
              }

              // Add logic to choose profile picture
            },
            child: const Text('Choose Profile Picture'),
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            controller: name,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Bio',
            ),
            controller: bio,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseChatCore.instance.createUserInFirestore(
                  types.User(
                    firstName: name.text,
                    lastName: controller.address,
                    id: user.uid, // UID from Firebase Authentication
                    imageUrl: user.photoURL,
                  ),
                );
                userController.setUser(WalletUser(
                  pfpUrl: user.photoURL ?? "",
                  walletAddress: controller.address!,
                  accountName: name.text,
                  bio: bio.text,
                ));
                await FirebaseUtils.users
                    .doc(controller.address)
                    .set(userController.toJson());
                Get.off(() => const NavBar());
              },
              child: const Text('Submit')),
        ],
      ),
    );
  }
}
