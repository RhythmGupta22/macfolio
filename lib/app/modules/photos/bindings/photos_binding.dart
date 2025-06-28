import 'package:get/get.dart';

import '../controllers/photos_controller.dart';

class PhotosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotosController>(
      () => PhotosController(),
    );
  }
}
