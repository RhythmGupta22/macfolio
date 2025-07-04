import 'package:flutter/material.dart';

class Dock extends StatelessWidget {
  const Dock({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Reference width for full-size dock
    const double referenceWidth = 1440;
    final double scaleFactor = (screenWidth / referenceWidth).clamp(0.3, 1.0);

    return Transform.scale(
      scale: scaleFactor,
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(40, 40, 40, 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color.fromRGBO(72, 72, 72, 1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/Finder.png', scale: 1.8),
            Image.asset('assets/icons/Launchpad.png', scale: 1.8),
            Image.asset('assets/icons/Contacts.png', scale: 1.8),
            Image.asset('assets/icons/Music.png', scale: 1.8),
            Image.asset('assets/icons/Calculator.png', scale: 1.8),
            Image.asset('assets/icons/Photos.png', scale: 1.8),
            Image.asset('assets/icons/Numbers.png', scale: 1.8),
            Image.asset('assets/icons/Terminal.png', scale: 1.8),
            Image.asset('assets/icons/Me.png', scale: 1.8),
            Container(
              height: 40,
              width: 1,
              color: const Color.fromRGBO(104, 104, 104, 1),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            Image.asset('assets/icons/Trash Full.png', scale: 1.8),
          ],
        ),
      ),
    );
  }
}