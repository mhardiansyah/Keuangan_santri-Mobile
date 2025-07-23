import 'package:get/get.dart';

import '../controllers/isi_data_controller.dart';

class IsiDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IsiDataController>(
      () => IsiDataController(),
    );
  }
}
