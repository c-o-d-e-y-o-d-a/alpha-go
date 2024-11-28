import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/300'), // Dummy user PFP
          ),
        ),
        titleSpacing: 0, // Remove default spacing between title and leading
        title: const Padding(
          padding: EdgeInsets.only(right: 16.0), // Move text to the right
          child: Text(
            "User Name",
            style: TextStyle(
              color: Color(0xFFB4914B), // Gold color
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call,
                color: Color(0xFFB4914B)), // Gold call icon
            onPressed: () {
              // Call functionality here
            },
          ),
        ],
        centerTitle:
            false, // Keep the title left aligned relative to the avatar
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'), // Background image asset
            fit: BoxFit.cover,
            opacity: 1, // Adjust opacity if needed
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 10, // Example message count
                itemBuilder: (context, index) {
                  bool isSender = index % 2 == 0; // Alternate sender/receiver
                  return Align(
                    alignment:
                        isSender ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isSender
                            ? const Color(0xFF3A3A3A) // Grey background
                            : const Color(0xFF121212), // Black background
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isSender ? 12.0 : 0.0),
                          topRight: Radius.circular(isSender ? 0.0 : 12.0),
                          bottomLeft: const Radius.circular(12.0),
                          bottomRight: const Radius.circular(12.0),
                        ),
                        border: Border.all(
                          color: const Color(0xFFB4914B), // Gold border
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSender ? "12:$index PM" : "12:$index AM",
                            style: const TextStyle(
                              color: Color(0xFFB4914B), // Gold text
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSender
                                ? "This is a message from you."
                                : "This is a message from them.",
                            style: const TextStyle(
                              color: Colors.white, // Message text
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: const Color(0xFFB4914B), // Gold background for input box
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        hintStyle: const TextStyle(
                          color: Colors.black, // Black hint text
                        ),
                        filled: true,
                        fillColor: const Color(
                            0xFFFFF8E1), // Lighter gold for text field
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () {
                      // Send message functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
