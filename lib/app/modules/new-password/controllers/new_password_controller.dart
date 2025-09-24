import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  //TODO: Implement NewPasswordController

  final count = 0.obs;
  var url = dotenv.env['base_url'];
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;
  var passwordError = ''.obs;
  var newPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future resetPassword() async {
    final token = Get.arguments['token'];

    // Reset error messages
    passwordError.value = '';
    newPasswordError.value = '';

    // Validasi password dan confirmPassword
    if (password.value.isEmpty || confirmPassword.value.isEmpty) {
      passwordError.value = 'Password wajib diisi';
      newPasswordError.value = 'Password wajib diisi';
      Get.snackbar(
        "Error",
        "Password wajib diisi",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password.value != confirmPassword.value) {
      passwordError.value = 'Password tidak sama';
      newPasswordError.value = 'Password tidak sama';
      Get.snackbar(
        "Error",
        "Password tidak sama",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final urlReset = Uri.parse("${url}/auth/reset-password");
      final response = await http.post(
        urlReset,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'newPassword': password.value}),
      );
      if (response.statusCode == 201) {
        print("response status code: ${response.statusCode}");
        print("response body: ${response.body}");
        Get.snackbar(
          "Berhasil",
          jsonDecode(response.body)["message"] ?? "Password berhasil direset",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(
          const Duration(seconds: 1),
          () => Get.toNamed(Routes.LOGIN),
        );
      } else {
        Get.snackbar(
          "Error",
          jsonDecode(response.body)["message"] ?? "Terjadi kesalahan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('error: $e');
      Get.snackbar(
        "Error",
        "Tidak bisa terhubung ke server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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
