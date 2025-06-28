import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/terminal_controller.dart';

class TerminalView extends GetView<TerminalController> {
  const TerminalView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TerminalView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TerminalView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
