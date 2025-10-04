// lib/app/widgets/common/draggable_window.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class DraggableWindow extends StatefulWidget {
  final String title;
  final List<String> items;
  final VoidCallback onClose;
  final void Function(String, List<String>) onFolderTap;
  final VoidCallback? onMinimize;

  const DraggableWindow({
    super.key,
    required this.title,
    required this.items,
    required this.onClose,
    required this.onFolderTap,
    this.onMinimize,
  });

  @override
  State<DraggableWindow> createState() => _DraggableWindowState();
}

class _DraggableWindowState extends State<DraggableWindow> {
  Offset offset = const Offset(200, 150);
  String currentSection = '';

  @override
  void initState() {
    super.initState();
    currentSection = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    final sections = ['Desktop', 'All Applications', 'Trash'];
    final items = _getItemsFor(currentSection, widget.items);

    final windowContent = Material(
      elevation: 16,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 500, height: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF23262F), // macOS dark window
                  const Color(0xFF2C2F38),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF44464D)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(46),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(children: [
              // Enhanced Mac-style Title bar
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF35363A), // macOS header gradient
                      const Color(0xFF23262F),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  border: Border(bottom: BorderSide(color: const Color(0xFF44464D), width: 0.5)),
                ),
                child: Row(
                  children: [
                    // Mac-style window controls
                    Row(
                      children: [
                        _MacWindowControl(
                          color: const Color(0xFFFF5F57),
                          onTap: widget.onClose,
                          tooltip: 'Close',
                        ),
                        const SizedBox(width: 6),
                        _MacWindowControl(
                          color: const Color(0xFFFFBD2E),
                          onTap: () => widget.onMinimize?.call(), // Fixed null safety
                          tooltip: 'Minimize',
                        ),
                        const SizedBox(width: 6),
                        _MacWindowControl(
                          color: const Color(0xFF28C940), // macOS green
                          onTap: () {},
                          tooltip: 'Maximize',
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Text(
                        currentSection,
                        style: const TextStyle(
                          color: Color(0xFFECECEC),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Content area
              Expanded(
                child: Row(children: [
                  // Sidebar
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2C2F38),
                          const Color(0xFF23262F),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border(right: BorderSide(color: const Color(0xFF44464D), width: 0.5)),
                    ),
                    child: ListView(
                      children: sections.map((sec) {
                        final isSel = sec == currentSection;
                        return ListTile(
                          title: Text(
                            sec,
                            style: TextStyle(
                              color: isSel ? const Color(0xFFECECEC) : const Color(0xFFB0B3B8),
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          selected: isSel,
                          selectedTileColor: const Color(0xFF35363A).withAlpha(179), // Changed from withOpacity
                          onTap: () => setState(() => currentSection = sec),
                        );
                      }).toList(),
                    ),
                  ),

                  // Divider
                  Container(width: 1, color: const Color(0xFF44464D)),

                  // Content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(
                              item,
                              style: const TextStyle(color: Color(0xFFECECEC)),
                            ),
                            onTap: () => widget.onFolderTap(item, _defaultItems(item)),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: (d) => setState(() => offset += d.delta),
            child: windowContent,
          ),
        ),
      ],
    );
  }

  List<String> _getItemsFor(String section, List<String> initial) {
    if (section == 'Desktop') return initial;
    if (section == 'All Applications') return ['Chrome', 'VS Code', 'Figma', 'Calendar', 'Slack'];
    if (section == 'Trash') return ['old_resume.pdf', 'temp.txt'];
    return initial;
  }

  List<String> _defaultItems(String folderName) {
    return ['file1', 'file2', '$folderName-child-folder'];
  }
}

// Mac-style window control button
class _MacWindowControl extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;
  final String tooltip;

  const _MacWindowControl({
    required this.color,
    required this.onTap,
    required this.tooltip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black.withAlpha(38), // Changed from withOpacity
              width: 1
            ),
          ),
        ),
      ),
    );
  }
}