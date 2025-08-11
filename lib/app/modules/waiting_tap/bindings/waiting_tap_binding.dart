import 'package:get/get.dart';

import '../controllers/waiting_tap_controller.dart';

class WaitingTapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaitingTapController>(
      () => WaitingTapController(),
    );
  }
}
