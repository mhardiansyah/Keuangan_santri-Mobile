// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // Reactive variables for email and password
  var email = ''.obs;
  var password = ''.obs;

  // Reactive variables for error messages
  var emailError = RxnString();
  var passwordError = RxnString();

  // Reactive variable for password visibility
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  bool validateForm() {
    bool isValid = true;

    // Reset error messages
    emailError.value = null;
    passwordError.value = null;

    if (email.value.isEmpty) {
      emailError.value = 'Email tidak boleh kosong';
      isValid = false;
    } else if (!GetUtils.isEmail(email.value)) {
      emailError.value = 'Format email tidak valid';
      isValid = false;
    }
    if (password.value.isEmpty) {
      passwordError.value = 'Password tidak boleh kosong';
      isValid = false;
    } else if (password.value.length < 8) {
      passwordError.value = 'Password minimal 8 karakter';
      isValid = false;
    }

    return isValid;
  }

  void clearForm() {
    email.value = '';
    password.value = '';
    emailError.value = null;
    passwordError.value = null;
  }

  void login() async {
    if (validateForm()) {
      // Perform login logic here

      try {
        Uri urlLogin = Uri.parse('http://10.0.2.2:5000/auth/login/');
        var response = await http.post(
          urlLogin,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email.value, 'password': password.value}),
        );
        print('response.statusCode: ${response.statusCode}');
        if (response.statusCode == 201) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('login', response.body);
          Get.snackbar('Login', 'Login berhasil!');
          Get.offAllNamed(Routes.MAIN_NAVIGATION);
        } else {
          Get.snackbar('Login', 'Email atau password salah!');
        }
      } catch (e) {
        Get.snackbar('Login', 'Terjadi kesalahan, $e');
      }

      // clearForm();
    } else {
      Get.snackbar('Error', 'Silakan perbaiki kesalahan di login');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
