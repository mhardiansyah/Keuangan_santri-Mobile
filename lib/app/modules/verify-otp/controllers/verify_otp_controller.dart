import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class VerifyOtpController extends GetxController {
  //TODO: Implement VerifyOtpController

  final count = 0.obs;
  var url = dotenv.env['base_url'];
  var otp = ''.obs;
  var isloading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }
  
  void submitOtp() async {
    if (otp.value.isEmpty) {
      Get.snackbar("Error", "OTP wajib diisi",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.toNamed(Routes.NEW_PASSWORD, arguments: {"token": otp.value});
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
