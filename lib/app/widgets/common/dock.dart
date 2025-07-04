import 'package:flutter/material.dart';

class Dock extends StatelessWidget {
  const Dock({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Reference width for full-size dock
    const double referenceWidth = 1300;
    final double scaleFactor = (screenWidth / referenceWidth).clamp(0.3, 1.0);

    final List<String> dockIcons = [
      'Finder',
      'All Apps',
      'Contact Me',
      'Music',
      'Calculator',
      'Photos',
      'Skills',
      'Terminal',
      'About Me',
    ];

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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...dockIcons.map((iconName) => _HoverableIcon(iconName)).toList(),

              // Divider
              Container(
                height: 50,
                width: 1,
                color: const Color.fromRGBO(104, 104, 104, 1),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),

              _HoverableIcon('Trash'),
            ],
          ),
        ),
      ),
    );
  }
}
class _HoverableIcon extends StatefulWidget {
  final String assetName;

  const _HoverableIcon(this.assetName);

  @override
  State<_HoverableIcon> createState() => _HoverableIconState();
}

class _HoverableIconState extends State<_HoverableIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 👆 Tooltip shown above
          if (_isHovered)
            Positioned(
              top: -43,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(40, 40, 40, 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.assetName,
                  style: const TextStyle(
                    fontFamily: 'SFPro',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // 📦 Icon with hover animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Image.asset(
              'assets/icons/${widget.assetName}.png',
              scale: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}