// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

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

  void login() {
    if (validateForm()) {
      // Perform login logic here
      Get.snackbar('Login', 'Login successful');
      Get.toNamed(Routes.HOME);
      clearForm();
    } else {
      Get.snackbar('Error', 'Please fix the errors in the form');
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