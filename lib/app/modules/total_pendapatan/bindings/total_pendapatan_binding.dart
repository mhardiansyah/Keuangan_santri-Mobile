import 'package:get/get.dart';

import '../controllers/total_pendapatan_controller.dart';

class TotalPendapatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TotalPendapatanController>(
      () => TotalPendapatanController(),
    );
  }
}
