import 'package:get/get.dart';

import '../controllers/all_apps_controller.dart';

class AllAppsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllAppsController>(
      () => AllAppsController(),
    );
  }
}
