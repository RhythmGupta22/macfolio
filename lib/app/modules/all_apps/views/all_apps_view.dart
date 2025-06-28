import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/all_apps_controller.dart';

class AllAppsView extends GetView<AllAppsController> {
  const AllAppsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllAppsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AllAppsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
