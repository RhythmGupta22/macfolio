import 'package:flutter/material.dart';

class DraggableWindow extends StatefulWidget {
  final String title;
  final Widget content;
  final VoidCallback onClose;

  const DraggableWindow({
    super.key,
    required this.title,
    required this.content,
    required this.onClose,
  });

  @override
  State<DraggableWindow> createState() => _DraggableWindowState();
}

class _DraggableWindowState extends State<DraggableWindow> {
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
          });
        },
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.95),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'SFPro',
                        )),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 16),
                      onPressed: widget.onClose,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              Expanded(child: widget.content),
            ],
          ),
        ),
      ),
    );
  }
}