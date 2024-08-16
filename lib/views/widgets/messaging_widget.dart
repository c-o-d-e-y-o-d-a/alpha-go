import 'package:alpha_go/views/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key,
      required this.name,
      required this.message,
      required this.time});
  final String name;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final room = await FirebaseChatCore.instance.createRoom(
          types.User(
            firstName: 'tb1qyth54uk72e8m5xu43qwqh78r5atlmp905wzsrc',
            id: "kkzKneKvxcQdMIpUruTGrzkScjJ2", // UID from Firebase Authentication
            imageUrl: 'https://i.pravatar.cc/300',
            // lastName: 'Doe',
          ),
        );
        Get.to(() => ChatPage(room: room));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //color: Colors.red,
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.2)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text(name), Text(message)],
                ),
                Column(
                  children: [Text(time), const Spacer()],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
