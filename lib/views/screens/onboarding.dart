import 'dart:developer';
import 'dart:io';
import 'package:alpha_go/models/const_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:alpha_go/controllers/user_controller.dart';
import 'package:alpha_go/controllers/wallet_controller.dart';
import 'package:alpha_go/models/firebase_model.dart';
import 'package:alpha_go/models/user_model.dart';
import 'package:alpha_go/views/screens/base_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isUploading = false;
  TextEditingController name = TextEditingController();
  TextEditingController bio = TextEditingController();
  final WalletController controller = Get.find();
  final UserController userController = Get.find();
  final ImagePicker picker = ImagePicker();
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    log(controller.address.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/bg.jpg',
              ),
              fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create your profile'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          bottom: Constants.appBarBottom,
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: 5.h, right: 5.w, left: 5.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: const Color(0xffb4914b),
                  foregroundImage: !isUploading
                      ? NetworkImage(userController.user.pfpUrl ?? "")
                      : null,
                  child: isUploading ? const CircularProgressIndicator() : null,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: ElevatedButton(
                    style: Constants.buttonStyle,
                    onPressed: () async {
                      setState(() {
                        isUploading = true;
                      });
                      final mountainsRef = FirebaseUtils.userPfp
                          .child('${controller.address}.jpg');
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        File file = File(image.path);
                        try {
                          await mountainsRef.putFile(file).then((value) async {
                            await mountainsRef
                                .getDownloadURL()
                                .then((value) async {
                              log(value);
                              await user.updatePhotoURL(value).then((onValue) {
                                userController.updatePfpUrl(value);
                                setState(() {
                                  isUploading = false;
                                  log("done");
                                  log(user.photoURL.toString());
                                });
                              });
                              setState(() {});
                            });
                          });
                        } on FirebaseException catch (e) {
                          log(e.toString());
                        }
                      }
                    },
                    child: const Text('Choose Profile Picture'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: TextFormField(
                    style: Constants.inputStyle,
                    cursorColor: Colors.white,
                    decoration: Constants.inputDecoration.copyWith(
                      labelText: 'Name',
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                    maxLines: 1,
                    controller: name,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: TextFormField(
                    style: Constants.inputStyle,
                    cursorColor: Colors.white,
                    decoration: Constants.inputDecoration.copyWith(
                      labelStyle: const TextStyle(color: Colors.white),
                      labelText: 'Bio',
                    ),
                    controller: bio,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: ElevatedButton(
                      style: Constants.buttonStyle,
                      onPressed: () async {
                        await FirebaseChatCore.instance.createUserInFirestore(
                          types.User(
                            firstName: name.text,
                            lastName: controller.address,
                            id: user.uid, // UID from Firebase Authentication
                            imageUrl: userController.user.pfpUrl ?? "",
                          ),
                        );
                        userController.setUser(WalletUser(
                          pfpUrl: userController.user.pfpUrl ?? "",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
