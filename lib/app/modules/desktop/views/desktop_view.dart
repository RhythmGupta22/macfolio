import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/desktop_controller.dart';

class DesktopView extends GetView<DesktopController> {
  const DesktopView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DesktopView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DesktopView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
