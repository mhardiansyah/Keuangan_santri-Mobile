// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  var nameError = RxnString();
  var emailError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  bool validateForm() {
    bool isValid = true;

    nameError.value = null;
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    if (name.value.isEmpty) {
      nameError.value = 'Nama tidak boleh kosong';
      isValid = false;
    }
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
    if (confirmPassword.value.isEmpty) {
      confirmPasswordError.value = 'Konfirmasi password tidak boleh kosong';
      isValid = false;
    } else if (confirmPassword.value != password.value) {
      confirmPasswordError.value = 'Password tidak sama';
      isValid = false;
    }

    return isValid;
  }

  void clearForm() {
    name.value = '';
    email.value = '';
    password.value = '';
    emailError.value = null;
    passwordError.value = null;
  }

  void register() {
    if (validateForm()) {
      // Proses register di sini
      Get.snackbar('Register', 'Registrasi berhasil!');
      Get.offAllNamed(Routes.HOME);
      clearForm();
    }
    else {
      Get.snackbar('Error', 'Silakan perbaiki kesalahan di formulir');
    }
  }

  
}
