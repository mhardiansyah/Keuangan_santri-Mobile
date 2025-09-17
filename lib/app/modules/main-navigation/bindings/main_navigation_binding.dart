import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/controllers/product_controller.dart';
import 'package:sakusantri/app/modules/home/controllers/home_controller.dart';
import 'package:sakusantri/app/modules/pengaturan_toko/controllers/pengaturan_toko_controller.dart';
import 'package:sakusantri/app/modules/riwayat_hutang/controllers/riwayat_hutang_controller.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<PengaturanTokoController>(
      () => PengaturanTokoController(),
      fenix: true,
    );
    Get.lazyPut<RiwayatHutangController>(
      () => RiwayatHutangController(),
      fenix: true,
    );
  }
}
