import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/photos_controller.dart';

class PhotosView extends GetView<PhotosController> {
  const PhotosView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhotosView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PhotosView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
