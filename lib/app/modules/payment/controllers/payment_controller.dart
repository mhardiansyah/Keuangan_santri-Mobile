import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class PaymentController extends GetxController {
  var selectedMethod = ''.obs;
  // final box = GetStorage();

  //data arguments
  var santriId = 0.obs;
  var name = ''.obs;
  var passcode = ''.obs;
  var kelas = ''.obs;
  var saldo = 0.obs;
  var hutang = 0.obs;
  var kartuId = 0.obs;

  // data dariarguments cart
  var cartItems = [].obs;
  var totalHargaPokok = 0.obs;
  var pajak = 0.obs;
  var totalPembayaran = 0.obs;
  var url = dotenv.env['base_url'];

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      santriId.value = arguments['id'] ?? 0;
      name.value = arguments['nama'] ?? '';
      passcode.value = arguments['passcode'] ?? '';
      kelas.value = arguments['kelas'] ?? '';
      saldo.value = arguments['saldo'] ?? 0;
      hutang.value = arguments['hutang'] ?? 0;
      kartuId.value = arguments['kartu_id'] ?? 0;

      // cart
      cartItems.assignAll(arguments['cartItems'] ?? []);
      totalHargaPokok.value = arguments['totalHargaPokok'] ?? 0;
      pajak.value = arguments['pajak'] ?? 0;
      totalPembayaran.value = arguments['totalPembayaran'] ?? 0;
    }
    // print("passcode dari db: $passcode");
    print('isi args: $arguments');
    autoSelectMethod();
    bayarHutangOtamatis();
  }

  void selectMethod(String method) {
    selectedMethod.value = method;
  }

  void autoSelectMethod() {
    if (saldo.value > hutang.value) {
      // Saldo cukup buat bayar total
      selectedMethod.value = "Saldo";
    } else {
      // Kalau saldo kurang, otomatis ke hutang
      selectedMethod.value = "Hutang";
    }
  }

  Future bayarHutangOtamatis() async {
    if (saldo.value <= 0) {
      Get.snackbar(
        "saldo",
        "Saldo tidak mencukupi",
        backgroundColor: Colors.yellow,
        colorText: Colors.white,
      );
      return;
    }

    final urlDeduct = Uri.parse("$url/transaksi/deduct/${santriId.value}");
    int jumlahBayar = saldo.value <= hutang.value ? saldo.value : hutang.value;

    try {
      final response = await http.post(
        urlDeduct,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"jumlah": jumlahBayar}),
      );

      if (response.statusCode == 201) {
        saldo.value -= jumlahBayar;
        hutang.value -= jumlahBayar;
        Get.snackbar("Success", "Hutang berkurang $jumlahBayar");
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", 'Gagal bayar hutang otomatis');
        print('status code: ${response.statusCode}');
        print('gagal bayar hutang otomatis: ${error['message']}');
      }
    } catch (e) {
      print("Error bayar hutang otomatis: $e");
    }
  }

  Future transaksi() async {
    if (selectedMethod.value.isEmpty) {
      Get.snackbar('Error', 'Pilih metode pembayaran');
      return;
    }

    final urlTransaksi = Uri.parse(
      selectedMethod.value == "Saldo"
          ? "$url/transaksi/deduct/${santriId.value}"
          : "$url/transaksi/hutang/${santriId.value}",
    );

    try {
      final response = await http.post(
        urlTransaksi,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"jumlah": totalPembayaran.value}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // saldo.value = saldo.value - totalPembayaran.value;
        if (selectedMethod.value == "Saldo") {
          saldo.value -= totalPembayaran.value;
        } else {
          hutang.value += totalPembayaran.value;
        }

        Get.snackbar(
          "Success",
          "Pembayaran Berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(
          Routes.NOTIF_PEMBAYARAN,
          arguments: {
            'method': selectedMethod.value,
            'total': totalPembayaran.value,
            'nama': name.value,
            // 'passcode': passcode.value,
            'santriId': santriId.value,
            'type': TransaksiType.pembayaran,
            'cartItems': cartItems,
            'totalHargaPokok': totalHargaPokok.value,
            'pajak': pajak.value,
            'totalPembayaran': totalPembayaran.value,
            'saldo': saldo.value,
            'hutang': hutang.value,
          },
        );
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error", "Pembayaran Gagal");
        print('status: ${response.statusCode}');
        print('Error: ${error['msg']}');
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan");
      print('kesalahan: $e');
    }
  }
}
