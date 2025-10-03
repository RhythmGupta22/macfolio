// lib/app/widgets/common/desktop_icon.dart
import 'package:flutter/material.dart';

enum DesktopIconType { file, folder }

class DesktopIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final DesktopIconType type;
  final Offset initialPosition;
  final VoidCallback? onDoubleTap;

  const DesktopIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.type,
    this.initialPosition = const Offset(80, 80),
    this.onDoubleTap,
  });

  @override
  State<DesktopIcon> createState() => _DesktopIconState();
}

class _DesktopIconState extends State<DesktopIcon> {
  late Offset _position;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        left: _position.dx,
        top: _position.dy,
        child: GestureDetector(
          onPanUpdate: (d) => setState(() => _position += d.delta),
          onDoubleTap: widget.onDoubleTap,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: Column(children: [
              Icon(widget.icon, size: 48, color: _hover ? Colors.white : Colors.grey[200]),
              const SizedBox(height: 4),
              Text(widget.label, style: const TextStyle(color: Colors.white)),
            ]),
          ),
        ),
      ),
    ]);
  }
}