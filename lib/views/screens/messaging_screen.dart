import 'package:alpha_go/views/widgets/messaging_widget.dart';
import 'package:flutter/material.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messaging"),
      ),
      body: const Center(
        child: Column(
          children: [
            MessageWidget(
              name: "Account 1",
              message: "Last Message",
              time: "Time",
            ),
            MessageWidget(
              name: "Account 3",
              message: "Last Message",
              time: "Time",
            ),
            MessageWidget(
              name: "Account 2",
              message: "Last Message",
              time: "Time",
            ),
          ],
        ),
      ),
    );
  }
}
