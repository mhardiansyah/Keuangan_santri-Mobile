// ignore_for_file: unused_import

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final box = GetStorage();
  RxString logined = "".obs;

  void onInit() {
    super.onInit();
    // cekData();
  }

  // cekData() async {
  //   String? access_token = box.read('access_token');

  //   if (access_token != null) {
  //     logined.value = access_token;
  //     Get.offAllNamed(Routes.HOME);
  //   } else {
  //     Get.offAllNamed(Routes.LOGIN);
  //   }
  // }
}
