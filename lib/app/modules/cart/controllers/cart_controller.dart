// ignore_for_file: override_on_non_overriding_member, unnecessary_null_comparison, unused_import

import 'dart:convert';
import 'dart:ffi';

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/cart_models.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';

class CartController extends GetxController {
  //TODO: Implement CartController

  final count = 0.obs;
  var cartItems = <CartModels>[].obs;
  final box = GetStorage();
  var searchKeyword = ''.obs;
  var url = dotenv.env['base_url'];
  List<Items> allItems = [];
  var itemsList = <Items>[].obs;
  var barcode = ''.obs;
  final focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () => focusNode.requestFocus());
    print('focusNode: $focusNode');
    fetchProduct();
  }

  KeyEventResult onkeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final char = event.character ?? event.logicalKey.keyLabel;
      print("Key pressed: '$char' | logicalKey: ${event.logicalKey.debugName}");

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        print("Full barcode scanned: '${barcode.value}'");
        scanBarcode(barcode.value.trim());
        barcode.value = '';
      } else if (char.isNotEmpty && char.length == 1) {
        barcode.value += char;
      }
    }
    return KeyEventResult.handled;
  }

  void scanBarcode(String barcode) {
    final product = allItems.firstWhereOrNull(
      (item) => item.barcode == barcode,
    );
    if (product != null) {
      addCart(product);

      Get.snackbar(
        'Success',
        'Added ${product.nama} ke keranjang',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'Produk dengan barcode $barcode tidak ditemukan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Product not found: $barcode");
    }
  }

  void fetchProduct() async {
    try {
      var urlItems = Uri.parse("${url}/items");
      final response = await http.get(urlItems);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(response.body);
        print(json.decode(response.body));

        final List<dynamic> data = jsonresponse['data'];
        print('data mentah : $data');

        allItems = data.map((item) => Items.fromJson(item)).toList();
        filterProducts();
      } else {
        print("Failed with status code: ${response.statusCode}");
        Get.snackbar('Error', 'Failed to fetch products');
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "Failed to fetch products $e",
        backgroundColor: Colors.red,
      );
    } finally {}
  }

  void filterProducts() {
    final keyword = searchKeyword.value.toLowerCase();
    itemsList.assignAll(
      allItems.where((item) {
        final machtkeyword = (item.nama).toLowerCase().contains(keyword);

        return machtkeyword;
      }),
    );
  }

  void addCart(Items product) {
    int index = cartItems.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      cartItems[index].jumlah += 1;
      cartItems.refresh();
    } else {
      cartItems.add(CartModels(product: product));
    }
  }

  void removeCart(Items product) {
    cartItems.removeWhere((e) => e.product.id == product.id);
  }

  void incjumlah(CartModels item) {
    item.jumlah += 1;
    cartItems.refresh();
  }

  void decjumlah(CartModels item) {
    if (item.jumlah > 1) {
      item.jumlah -= 1;
      cartItems.refresh();
    } else {
      // removeCart(item.product);
    }
  }

  void clear() {
    saveDataPayment();
    cartItems.clear();
  }

  int get totalHargaPokok =>
      cartItems.fold(0, (sum, item) => sum + item.jumlah * item.product.harga);

  int get pajak {
    int totalitem = cartItems.fold(0, (sum, item) => sum + item.jumlah);
    return totalitem * 500;
  }

  int get totalPembayaran => totalHargaPokok + pajak;

  void saveDataPayment() {
    // Implement save data logic here
    if (cartItems == null) {
      Get.snackbar('Error', 'Keranjang kosong');
    }
    box.write('totalPembayaran', totalPembayaran);
    box.write(
      'cartItem',
      cartItems
          .map(
            (e) => {
              "product": {"id": e.product.id, "nama": e.product.nama},
              "jumlah": e.jumlah,
            },
          )
          .toList(),
    );

    print('isi dari cart (disimpan ke storage): ${box.read('cartItem')}');
  }
}
