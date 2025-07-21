// ignore_for_file: unused_import

import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed('/home'); // Navigate to login after splash
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
