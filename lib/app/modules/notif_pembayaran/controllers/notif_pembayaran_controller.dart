import 'dart:convert';

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

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    print("Arguments diterima: $args");
    if (args != null) {
      totalHarga.value = args['total'] ?? 0;
      selectedMethod.value = args['method'] ?? '-';
      santriName.value = args['santriName'] ?? 'User';
      santriId.value = args['santriId'] ?? 0;
      transaksiType.value = args['type'] ?? '-';
    }
  }

  Future<void> checkout(int santriId) async {
    try {
      final box = GetStorage();
      final List<dynamic> cartItems = box.read('cartItem') ?? [];
      print("Items di cart: $cartItems");

      if (cartItems.isEmpty) {
        Get.snackbar('Error', 'Keranjang kosong');
        return;
      }

      final body = {
        "santriId": santriId,
        "items":
            cartItems
                .map(
                  (item) => {
                    "itemId": item['product']['id'],
                    "quantity": item['jumlah'],
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
        Get.snackbar('Success', 'Checkout berhasil');
        box.remove('cartItem');
      } else {
        print("Checkout gagal: ${response.body}");
        Get.snackbar('Error', 'Checkout gagal');
      }
    } catch (e) {
      print("Error fungsi checkout: $e");
    }
  }
}
