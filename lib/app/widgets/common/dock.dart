// lib/widgets/common/dock.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Dock extends StatefulWidget {
  final void Function(String label)? onIconTap;
  final Map<String, bool>? minimizedStates;
  const Dock({super.key, this.onIconTap, this.minimizedStates});

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  double? _mouseX; // Mouse X position within dock
  bool _isDockHovered = false;
  final icons = [
    'Finder', 'All Apps', 'Contact Me', 'Music',
    'Calculator', 'Photos', 'Skills', 'Terminal',
    'About Me'
  ];

  // Icon layout constants
  static const double iconWidth = 48.0;
  static const double iconSpacing = 8.0;
  static const double maxScale = 0.6; // 1.6x (lowered)
  static const double sigma = 30.0; // Spread of wave
  static const double iconBaseHeight = 48.0; // base icon height
  static const double dockScale = 1.08; // Slightly increase dock size when hovered

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mouseX = event.localPosition.dx;
          _isDockHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _mouseX = null;
          _isDockHovered = false;
        });
      },
      child: AnimatedScale(
        scale: _isDockHovered ? dockScale : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(40, 40, 40, 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color.fromRGBO(72, 72, 72, 1)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...icons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final name = entry.value;
                  final center = index * (iconWidth + iconSpacing) + iconWidth / 2 + iconSpacing;
                  final scale = _mouseX == null
                    ? 1.0
                    : 1.0 + maxScale * math.exp(-math.pow((_mouseX! - center), 2) / (2 * math.pow(sigma, 2)));
                  final pop = _mouseX == null
                    ? 0.0
                    : iconBaseHeight * (scale - 1.0);
                  final isMinimized = widget.minimizedStates != null && (widget.minimizedStates![name] ?? false);
                  return _WaveIcon(
                    name,
                    scale: scale,
                    pop: pop,
                    onTap: () => widget.onIconTap?.call(name),
                    isMinimized: isMinimized,
                  );
                }),
                Container(
                  width: 1, height: 40,
                  color: const Color.fromRGBO(104, 104, 104, 1),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                // Trash icon
                (() {
                  final index = icons.length;
                  final center = index * (iconWidth + iconSpacing) + iconWidth / 2 + iconSpacing;
                  final scale = _mouseX == null
                    ? 1.0
                    : 1.0 + maxScale * math.exp(-math.pow((_mouseX! - center), 2) / (2 * math.pow(sigma, 2)));
                  final pop = _mouseX == null
                    ? 0.0
                    : iconBaseHeight * (scale - 1.0);
                  return _WaveIcon(
                    'Trash',
                    scale: scale,
                    pop: pop,
                    onTap: () => widget.onIconTap?.call('Trash'),
                  );
                })(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WaveIcon extends StatefulWidget {
  final String assetName;
  final VoidCallback? onTap;
  final double scale;
  final double pop;
  final bool isMinimized;
  const _WaveIcon(this.assetName, {this.onTap, required this.scale, required this.pop, this.isMinimized = false});
  @override
  State<_WaveIcon> createState() => _WaveIconState();
}

class _WaveIconState extends State<_WaveIcon> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    final double scale = widget.scale;
    final double baseHeight = 48.0;
    final double pop = (baseHeight * (scale - 1.0)) / scale;
    final double tooltipOffset = -baseHeight * scale - 12;
    final double dotSize = 6.0 * scale.clamp(1.0, 1.6); // Dot scales with magnification
    final double dotBaseTop = -baseHeight * scale / 2 - 4; // Default dot position
    final double dotTooltipTop = tooltipOffset - dotSize - 4; // Dot above tooltip
    final double dotTop = _isHovered ? dotTooltipTop : dotBaseTop;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (_isHovered)
              Positioned(
                top: tooltipOffset,
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..scale(scale)
                  ..translate(0.0, -pop),
                child: Image.asset(
                  'assets/icons/${widget.assetName}.png',
                  height: baseHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (widget.isMinimized)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutExpo,
                top: dotTop,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutExpo,
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}