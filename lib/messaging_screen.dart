import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

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
            // SearchField(
            //   /// widget to show when suggestions are empty
            //   emptyWidget: Container(
            //       // decoration: suggestionDecoration,
            //       height: 200,
            //       child: const Center(
            //           child: CircularProgressIndicator(
            //         color: Colors.white,
            //       ))),
            //   hint: 'Search for Users',
            //   itemHeight: 50,
            //   scrollbarDecoration: ScrollbarDecoration(),
            //   suggestionStyle:
            //       const TextStyle(fontSize: 24, color: Colors.white),
            //   suggestions: ['Account 1', 'Account 2', 'Account 3', 'Account 4']
            //       .map((e) => SearchFieldListItem(e, child: Text(e)))
            //       .toList(),
            //   suggestionState: Suggestion.expand,
            // ),
            messageWidget(
              name: "Account 1",
              message: "Last Message",
              time: "Time",
            ),
            messageWidget(
              name: "Account 3",
              message: "Last Message",
              time: "Time",
            ),
            messageWidget(
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

class messageWidget extends StatelessWidget {
  const messageWidget(
      {super.key,
      required this.name,
      required this.message,
      required this.time});
  final String name;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [Text(name), Text(message)],
              ),
              Column(
                children: [Text(time), Spacer()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
