// ignore_for_file: unused_import

import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;

  RxString logined = "".obs;

  cekData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();


  }

  void increment() => count.value++;
}
