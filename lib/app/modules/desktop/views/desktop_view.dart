import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/desktop_controller.dart';
import '../../../widgets/common/desktop_icon.dart';
import '../../../widgets/common/dock.dart';

class DesktopView extends GetView<DesktopController> {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Stack(
        children: [
          // Desktop Icon (like README or Applications)
          const Positioned(
            left: 40,
            top: 80,
            child: DesktopIcon(
              icon: Icons.folder,
              label: 'Applications',
              onTap: null, // Will update later to open window
            ),
          ),
          const Positioned(
            left: 40,
            top: 180,
            child: DesktopIcon(
              icon: Icons.note,
              label: 'README',
              onTap: null,
            ),
          ),

          // Dock at bottom
          const Align(
            alignment: Alignment.bottomCenter,
            child: Dock(),
          ),
        ],
      ),
    );
  }
}
