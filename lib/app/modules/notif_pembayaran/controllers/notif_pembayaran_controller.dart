import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotifPembayaranController extends GetxController {
  var totalHarga = 0.obs;
  var selectedMethod = ''.obs;
  var santriName = ''.obs;
  var santriId = 0.obs;
  var transaksiType = ''.obs;
  var url = dotenv.env['base_url'];
  var isLoading = false.obs;


  // data dariarguments cart
  var cartItems = [].obs;
  var totalHargaPokok = 0.obs;
  var pajak = 0.obs;
  var totalPembayaran = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    print("Arguments diterima: $args");
    if (args != null) {
      totalHarga.value = args['total'] ?? 0;
      selectedMethod.value = args['method'] ?? '-';
      santriName.value = args['nama'] ?? 'User';
      santriId.value = args['santriId'] ?? 0;
      transaksiType.value = args['type'] ?? '-';
      // cart
      cartItems.assignAll(args['cartItems'] ?? []);
      totalHargaPokok.value = args['totalHargaPokok'] ?? 0;
      pajak.value = args['pajak'] ?? 0;
      totalPembayaran.value = args['totalPembayaran'] ?? 0;
    }
  }

  Future<void> checkout(int santriId) async {
    try {
      print("Items di cart: $cartItems");

      if (cartItems.isEmpty) {
        Get.snackbar(
          'Error',
          'Keranjang kosong',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final body = {
        "santriId": santriId,
        "items":
            cartItems
                .map(
                  (item) => {
                    "itemId": item['itemId'],
                    "quantity": item['quantity'],
                  },
                )
                .toList(),
      };

      final response = await http.post(
        Uri.parse(
          selectedMethod.value == "Saldo"
              ? "$url/history/checkout"
              : "$url/history/hutang",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Checkout berhasil',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("Checkout gagal: ${response.body}");
        Get.snackbar(
          'Error',
          'Checkout gagal',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error fungsi checkout: $e");
    }
  }
}
