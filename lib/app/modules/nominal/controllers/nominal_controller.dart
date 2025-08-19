import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/modules/main-navigation/controllers/main_navigation_controller.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class NominalController extends GetxController {
  var selectedNominal = 0.obs; // jumlah nominal
  var inputText = ''.obs; // ✅ ganti TextEditingController dengan RxString

  final quickAmounts = [20000, 50000, 70000, 100000, 300000, 500000];
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  var url = dotenv.env['base_url'];

  final controllerMain = Get.find<MainNavigationController>();

  @override
  void onInit() {
    super.onInit();

    // Sinkronisasi input text dengan pilihan nominal
    ever(selectedNominal, (val) {
      inputText.value =
          selectedNominal.value == 0
              ? ''
              : currencyFormatter.format(selectedNominal.value);
    });
  }

  void pilihNominal(int amount) {
    selectedNominal.value = amount;
  }

  void updateNominalFromText(String value) {
    String numeric = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeric.isNotEmpty) {
      selectedNominal.value = int.parse(numeric);
    } else {
      selectedNominal.value = 0;
    }
  }

  Future topUpSaldo() async {
    final amount = selectedNominal.value;

    if (amount <= 0) {
      Get.snackbar(
        'Error',
        'Pilih nominal yang valid',
        backgroundColor: Colors.red,
      );
      return;
    }

    final urlTopup = Uri.parse(
      "$url/transaksi/top-up/${controllerMain.santriId.value}",
    );

    try {
      final response = await http.post(
        urlTopup,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"jumlah": amount}),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        Get.toNamed(Routes.NOTIF_PEMBAYARAN);
        Get.snackbar("Sukses", data['msg'] ?? "Saldo berhasil ditambahkan");
      } else {
        Get.snackbar("Error", data['msg'] ?? "Gagal top up");
        print("Error : $data");
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat terhubung ke server");
      print("error : $e");
    }
  }
}
