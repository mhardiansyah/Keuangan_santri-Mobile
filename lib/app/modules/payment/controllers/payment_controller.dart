// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class PaymentController extends GetxController {
  var selectedMethod = ''.obs;
  final box = GetStorage();

  //data arguments
  var santriId = 0.obs;
  var name = ''.obs;
  var passcode = ''.obs;
  var kelas = ''.obs;
  var saldo = 0.obs;
  var hutang = 0.obs;

  // data dari getorage
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
    }
    totalHargaPokok.value = box.read('totalHargaPokok') ?? 0;
    pajak.value = box.read('pajak') ?? 0;
    totalPembayaran.value = box.read('totalPembayaran') ?? 0;
    // print("passcode dari db: $passcode");
  }

  void selectMethod(String method) {
    selectedMethod.value = method;
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

        saldo.value = saldo.value - totalPembayaran.value;
        Get.snackbar("Success", "Pembayaran Berhasil");
        Get.toNamed(
          Routes.NOTIF_PEMBAYARAN,
          arguments: {
            'method': selectedMethod.value,
            'total': totalPembayaran.value,
            'santriName': name.value,
            // 'passcode': passcode.value,
            'santriId': santriId.value,
            'type': TransaksiType.pembayaran,
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