import 'package:flutter/material.dart';

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
    );
  }
}
