import 'package:alpha_go/views/screens/chat-screens/chat.dart';
import 'package:alpha_go/views/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomNavBar(
        username: "@TB1QT5JWMV83D...",
        onAddPressed: () {
          print("Add Pressed");
        },
        onMenuPressed: () {
          print("Menu Pressed");
        },
        onCopyPressed: () {
          print("Copy Pressed");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            // Search Bar with Icons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40, // Reduced height
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: const TextStyle(color: Color(0xFFB4914B)),
                        filled: true,
                        
                        fillColor: const Color.fromARGB(255, 85, 84, 84),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  height: 40, // Match height of search bar
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4914B), // Gold color
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  height: 40, // Match height of search bar
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB4914B), // Gold color
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Chatrooms Section
            const Text(
              "Chatrooms",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 140.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4, // Example count
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.black, // Black background
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: const Color(0xFFB4914B), // Gold border
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          
                          const Spacer(),
                          const Text(
                            "Gold Text",
                            style: TextStyle(
                              color: Colors.white, // Gold text
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 28.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Chats Section
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example chat count
                itemBuilder: (context, index) {
                  return MessageWidget(
                    name: "Person ${index + 1}",
                    message:
                        "This is a sample",
                    time: "12:${index}0 PM",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.name,
    required this.message,
    required this.time,
  });

  final String name;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final room = await FirebaseChatCore.instance.createRoom(
          const types.User(
            firstName: 'tb1qyth54uk72e8m5xu43qwqh78r5atlmp905wzsrc',
            id: "kkzKneKvxcQdMIpUruTGrzkScjJ2", // UID from Firebase Authentication
            imageUrl: 'https://i.pravatar.cc/300',
          ),
        );
        Get.to(() => ChatPage(room: room));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80, // Reduced height
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black, // Black background
           
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 30, // Reduced size for better alignment
                  backgroundColor: Colors.grey,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFFB4914B),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFFB4914B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
