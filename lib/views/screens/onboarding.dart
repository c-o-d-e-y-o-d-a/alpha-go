import 'dart:developer';
import 'dart:io';
import 'package:alpha_go/views/screens/onboarding.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    bool isUploading = false;
    TextEditingController name = TextEditingController();
    TextEditingController bio = TextEditingController();
    final storageRef = FirebaseStorage.instance.ref();
    final WalletController controller = Get.find();
    final UserController userController = Get.find();
    final ImagePicker picker = ImagePicker();
    final User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 70,

            foregroundImage: NetworkImage(user.photoURL ?? ""),
            // Add logic to display profile picture
          ),
          // Button to choose profile picture
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
            child: Text('Choose Profile Picture'),
          ),
          //SizedBox(height: 16), // Add some spacing between the buttons
          // Text field to enter name
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
            ),
            controller: name,
          ),
          // SizedBox(height: 16), // Add some spacing between the buttons
          // Text field to enter bio
          TextField(
            decoration: InputDecoration(
              labelText: 'Bio',
            ),
            controller: bio,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseChatCore.instance.createUserInFirestore(
                  types.User(
                    firstName: name.text,
                    id: user.uid, // UID from Firebase Authentication
                    imageUrl: user.photoURL,

                    // lastName: 'Doe',
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
                Get.to(() => const NavBar());
              },
              child: Text('Submit')),
        ],
      ),
    );
  }
}
