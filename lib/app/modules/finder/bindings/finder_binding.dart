import 'package:get/get.dart';

import '../controllers/finder_controller.dart';

class FinderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinderController>(
      () => FinderController(),
    );
  }
}
