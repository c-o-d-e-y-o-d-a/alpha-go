
import 'package:flutter/material.dart';

class GoldenButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GoldenButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xffb4914b), // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}