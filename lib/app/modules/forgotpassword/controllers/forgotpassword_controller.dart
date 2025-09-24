import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/routes/app_pages.dart';

class ForgotpasswordController extends GetxController {
  // Observables untuk email dan pesan error
  var email = ''.obs;
  var emailError = RxnString();
  var url = dotenv.env['base_url'];
  var isLoading = false.obs;

  // Fungsi validasi dan submit email
  void submitEmail() {
    // Validasi sederhana email
    if (email.value.isEmpty) {
      emailError.value = 'Email wajib diisi';
      return;
    }

    if (!GetUtils.isEmail(email.value)) {
      emailError.value = 'Format email tidak valid';
      return;
    }

    emailError.value = null;

    // TODO: Kirim request ke backend untuk reset password
    Get.snackbar(
      'Berhasil',
      'Link reset password telah dikirim ke ${email.value}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  Future forrgotPassword() async {
    try {
      if (email.value.isEmpty) {
        emailError.value = 'Email wajib diisi';
        Get.snackbar(
          "Error",
          "email wajib di isi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (!GetUtils.isEmail(email.value)) {
        emailError.value = 'Format email tidak valid';
        Get.snackbar(
          "typo",
          "format email tidak valid",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      emailError.value = null;

      var urlforgot = Uri.parse("${url}/auth/lupa-password");
      var response = await http.post(
        urlforgot,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.value}),
      );

      if (response.statusCode == 201) {
        final data = jsonEncode(response.body);
        print('data: $data');

        Get.snackbar(
          "Success",
          "Link reset password telah dikirim ke ${email.value}",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Future.delayed(
          const Duration(seconds: 1),
          () => Get.toNamed(
            Routes.VERIFY_OTP,
            // arguments: {"email": email.value}
          ),
        );
      } else {
        final error = jsonEncode(response.body);
        print('error: $error');
        Get.snackbar(
          "Error",
          "Link reset password telah dikirim ke ${email.value}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("error: $e");
      Get.snackbar(
        "Error",
        "Link reset password telah dikirim ke ${email.value}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Optional override

  @override
  void onClose() {
    email.value = '';
    emailError.value = null;
    super.onClose();
  }
}
