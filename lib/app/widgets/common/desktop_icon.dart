import 'package:flutter/material.dart';
import 'draggable_window.dart';

enum DesktopIconType { folder, file }

class DesktopIcon extends StatefulWidget {
  final IconData icon; // Can still use this as a fallback
  final String label;
  final Widget? windowContent;
  final Offset initialPosition;
  final DesktopIconType type;

  const DesktopIcon({
    super.key,
    required this.icon,
    required this.label,
    this.windowContent,
    this.initialPosition = const Offset(80, 80),
    this.type = DesktopIconType.folder,
  });

  @override
  State<DesktopIcon> createState() => _DesktopIconState();
}

class _DesktopIconState extends State<DesktopIcon> {
  late Offset _position;
  bool _showWindow = false;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  String _getIconAsset() {
    switch (widget.type) {
      case DesktopIconType.folder:
        return 'assets/icons/folder.png';
      case DesktopIconType.file:
        return 'assets/icons/Document.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _position += details.delta;
              });
            },
            onDoubleTap: () {
              if (widget.windowContent != null) {
                setState(() {
                  _showWindow = true;
                });
              }
            },
            child: Column(
              children: [
                Image.asset(_getIconAsset(), scale: 6),
                const SizedBox(height: 4),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'SFPro',
                  ),
                )
              ],
            ),
          ),
        ),

        if (_showWindow && widget.windowContent != null)
          DraggableWindow(
            title: widget.label,
            content: widget.windowContent!,
            onClose: () {
              setState(() {
                _showWindow = false;
              });
            },
          ),
      ],
    );
  }
}