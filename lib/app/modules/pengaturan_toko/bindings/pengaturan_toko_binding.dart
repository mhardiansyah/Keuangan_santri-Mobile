import 'package:get/get.dart';

import '../controllers/pengaturan_toko_controller.dart';

class PengaturanTokoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengaturanTokoController>(
      () => PengaturanTokoController(),
    );
  }
}
