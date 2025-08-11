import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/controllers/product_controller.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
