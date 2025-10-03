import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/common/dock.dart';
import '../../../widgets/common/desktop_icon.dart';
import '../../../widgets/common/menu_bar.dart';
import '../../../widgets/common/draggable_window.dart';
import '../../../widgets/spline_viewer_web.dart'; // Keep Spline import
import '../controllers/desktop_controller.dart';

class DesktopView extends StatefulWidget {
  const DesktopView({super.key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  final openWindows = <_WindowData>[];

  // This holds the actual desktop items
  final List<String> desktopItems = ['Applications', 'README.txt'];

  void _openWindow(String title, List<String> items) {
    final win = _WindowData(title, items);
    if (!openWindows.contains(win)) {
      setState(() => openWindows.add(win));
    }
  }

  void _closeWindow(_WindowData win) {
    setState(() => openWindows.remove(win));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Image.asset(
          'assets/images/bg_wallpaper.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // 🔳 3D Interactive background (for future use)
        // const SplineViewer(
        //   url: 'https://my.spline.design/interactivekeyboardbyabhinand-DnMtISP1Ir6KxIHxQeSkmV1V/',
        // ),

        const Positioned(top: 0, left: 0, right: 0, child: MacMenuBar()),

        // 🗂 Desktop Icons
        DesktopIcon(
          icon: Icons.folder,
          label: 'Applications',
          type: DesktopIconType.folder,
          initialPosition: const Offset(40, 120),
          onDoubleTap: () => _openWindow('Applications', ['Chrome', 'VS Code', 'Figma']),
        ),
        DesktopIcon(
          icon: Icons.description,
          label: 'README.txt',
          type: DesktopIconType.file,
          initialPosition: const Offset(40, 220),
          onDoubleTap: () => _openWindow('README.txt', ['This is your README']),
        ),

        // 🪟 Finder Windows
        for (final win in openWindows)
          DraggableWindow(
            key: ValueKey(win),
            title: win.title,
            items: _getWindowItems(win.title),
            onClose: () => _closeWindow(win),
            onFolderTap: (label, children) => _openWindow(label, children),
          ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Dock(
            onIconTap: (label) {
              _openWindow(label, ['Item 1', 'Item 2']);
            },
          ),
        ),
      ]),
    );
  }

  List<String> _getWindowItems(String title) {
    switch (title) {
      case 'Desktop':
        return desktopItems;
      case 'All Applications':
        return ['Chrome', 'VS Code', 'Figma', 'Calendar', 'Slack'];
      case 'Trash':
        return ['old_resume.pdf', 'temp.txt'];
      default:
        return ['File 1', 'File 2', '$title Folder'];
    }
  }
}

class _WindowData {
  final String title;
  final List<String> items;

  _WindowData(this.title, this.items);

  @override
  bool operator ==(Object other) =>
      other is _WindowData && other.title == title;

  @override
  int get hashCode => title.hashCode;
}