import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/desktop_controller.dart';
import '../../../widgets/common/desktop_icon.dart';
import '../../../widgets/common/dock.dart';
import '../../../widgets/common/menu_bar.dart';
import '../../../widgets/common/draggable_window.dart';
import '../../../widgets/spline_viewer_web.dart'; // ✅ Add this

class DesktopView extends GetView<DesktopController> {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Replace image with 3D Spline background
          const SplineViewer(
            url: 'https://my.spline.design/interactivekeyboardbyabhinand-DnMtISP1Ir6KxIHxQeSkmV1V/',
          ),

          // Mac-style Menu Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MacMenuBar(),
          ),

          // Example desktop icons
          DesktopIcon(
            icon: Icons.folder,
            label: 'Applications',
            type: DesktopIconType.folder,
            initialPosition: const Offset(40, 80),
            windowContent: const Text('Folder content goes here.'),
          ),
          DesktopIcon(
            icon: Icons.description,
            label: 'README.txt',
            type: DesktopIconType.file,
            initialPosition: const Offset(40, 180),
            windowContent: const Text('Readme file content.'),
          ),

          // Dock
          const Align(
            alignment: Alignment.bottomCenter,
            child: Dock(),
          ),
        ],
      ),
    );
  }
}