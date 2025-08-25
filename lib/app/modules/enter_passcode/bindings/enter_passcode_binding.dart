import 'package:get/get.dart';

import '../controllers/enter_passcode_controller.dart';

class EnterPasscodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnterPasscodeController>(
      () => EnterPasscodeController(),
    );
  }
}
