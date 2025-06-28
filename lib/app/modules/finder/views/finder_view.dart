import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/finder_controller.dart';

class FinderView extends GetView<FinderController> {
  const FinderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'FinderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
