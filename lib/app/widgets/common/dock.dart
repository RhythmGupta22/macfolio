import 'package:flutter/material.dart';

class Dock extends StatelessWidget {
  const Dock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.folder, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.person, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.code, color: Colors.white),
        ],
      ),
    );
  }
}
