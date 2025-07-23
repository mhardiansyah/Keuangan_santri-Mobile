// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IsiDataController extends GetxController {
  var namaPerusahaan = ''.obs;
  var alamat = ''.obs;
  var noTelp = ''.obs;
  var logoFile = Rxn<File>();

  var namaError = RxnString();
  var alamatError = RxnString();
  var telpError = RxnString();

  final ImagePicker _picker = ImagePicker();

  void pickLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      logoFile.value = File(pickedFile.path);
    }
  }

  bool validateForm() {
    bool isValid = true;
    namaError.value = null;
    alamatError.value = null;
    telpError.value = null;

    if (namaPerusahaan.value.isEmpty) {
      namaError.value = 'Nama perusahaan tidak boleh kosong';
      isValid = false;
    }
    if (alamat.value.isEmpty) {
      alamatError.value = 'Alamat tidak boleh kosong';
      isValid = false;
    }
    if (noTelp.value.isEmpty) {
      telpError.value = 'Nomor telepon tidak boleh kosong';
      isValid = false;
    }

    return isValid;
  }

  void kirimData() {
    if (validateForm()) {
      Get.snackbar('Sukses', 'Data perusahaan berhasil dikirim');
    } else {
      Get.snackbar('Gagal', 'Periksa kembali data yang diisi');
    }
  }
}
