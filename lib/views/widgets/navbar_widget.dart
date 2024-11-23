import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final VoidCallback onAddPressed;
  final VoidCallback onMenuPressed;
  final VoidCallback onCopyPressed;

  const CustomNavBar({
    Key? key,
    required this.username,
    required this.onAddPressed,
    required this.onMenuPressed,
    required this.onCopyPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20), // Only bottom-left is rounded
          bottomRight: Radius.circular(20), // Only bottom-right is rounded
        ),
        
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade300,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3),
        //   ),
        // ],

        border: const Border(
          bottom:
              BorderSide(color: Color(0xffb4914b), width: 2), // Bottom border
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 13), // Increased vertical padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffb4914b),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: username));
                      onCopyPressed();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Username copied!")),
                      );
                    },
                    child: const Icon(Icons.copy,
                        size: 18, color: Color(0xffb4914b)),
                  ),
                ],
              ),

              // Grouped icons for Add and Menu
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_box,
                        size: 26, color: Color(0xffb4914b)),
                    onPressed: onAddPressed,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu,
                        size: 29, color: Color(0xffb4914b)),
                    onPressed: onMenuPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0); // Increased height
}
