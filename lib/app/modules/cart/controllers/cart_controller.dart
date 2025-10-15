import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/cart_models.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class CartController extends GetxController {
  final count = 0.obs;
  var cartItems = <CartModels>[].obs;
  final box = GetStorage();
  var searchKeyword = ''.obs;
  var url = dotenv.env['base_url'];
  List<Items> allItems = [];
  var itemsList = <Items>[].obs;
  var barcode = ''.obs;
  final searchController = TextEditingController();

  final focusNode = FocusNode(); // scanner
  final searchFocusNode = FocusNode(); // search bar

  @override
  void onInit() {
    super.onInit();

    // Auto refocus ke scanner kalau search kosong
    focusNode.addListener(() {
      if (!focusNode.hasFocus && searchKeyword.value.isEmpty) {
        Future.delayed(const Duration(milliseconds: 50), () {
          focusNode.requestFocus();
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    fetchProduct();
  }

  /// Event dari KeyboardListener (scanner)
  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final char = event.character ?? event.logicalKey.keyLabel;

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        scanBarcode(barcode.value.trim());
        barcode.value = '';
      } else if (char.isNotEmpty && char.length == 1) {
        barcode.value += char;
      }
    }
  }

  /// Akhiri search dan kembalikan fokus ke scanner
  void endSearch() {
    searchKeyword.value = '';
    itemsList.clear();
    Future.delayed(const Duration(milliseconds: 50), () {
      focusNode.requestFocus();
    });
  }

  void scanBarcode(String code) {
    final product = allItems.firstWhereOrNull((item) => item.barcode == code);

    if (product == null) {
      Get.snackbar(
        'Error',
        'Produk dengan barcode $code tidak ditemukan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (product.jumlah == 0) {
      Get.snackbar(
        'Produk Habis',
        '${product.nama} sudah habis stoknya',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      addCart(product);
      Get.snackbar(
        'Success',
        'Added ${product.nama} ke keranjang',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void fetchProduct() async {
    try {
      var urlItems = Uri.parse("$url/items");
      final response = await http.get(urlItems);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(response.body);
        final List<dynamic> data = jsonresponse['data'];
        allItems = data.map((item) => Items.fromJson(item)).toList();
        filterProducts();
      } else {
        Get.snackbar('Error', 'Failed to fetch products');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch products $e",
        backgroundColor: Colors.red,
      );
    }
  }

  void filterProducts() {
    final keyword = searchKeyword.value.toLowerCase();
    itemsList.assignAll(
      allItems.where((item) {
        return item.jumlah > 0 && (item.nama).toLowerCase().contains(keyword);
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
    final maxStock = item.product.jumlah;

    if (item.jumlah < maxStock) {
      item.jumlah += 1;
      cartItems.refresh();
    } else {
      Get.snackbar(
        'Stok Habis',
        '${item.product.nama} stok maksimal ${item.product.jumlah}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void decjumlah(CartModels item) {
    if (item.jumlah > 1) {
      item.jumlah -= 1;
      cartItems.refresh();
    }
  }

  void goToWaitingTap() {
    final paymentData = saveDataPayment();
    Get.offAllNamed(Routes.WAITING_TAP, arguments: paymentData);
    cartItems.clear();
  }

  int get totalHargaPokok =>
      cartItems.fold(0, (sum, item) => sum + item.jumlah * item.product.harga);

  int get pajak {
    int totalitem = cartItems.fold(0, (sum, item) => sum + item.jumlah);
    return totalitem * 500;
  }

  int get totalPembayaran => totalHargaPokok + pajak;

  Map<String, dynamic> saveDataPayment() {
    return {
      'totalHargaPokok': totalHargaPokok,
      'pajak': pajak,
      'totalPembayaran': totalPembayaran,
      'cartItems':
          cartItems
              .map(
                (element) => {
                  'itemId': element.product.id,
                  'namaProduk': element.product.nama,
                  'quantity': element.jumlah.toInt(),
                  'harga': element.product.harga,
                },
              )
              .toList(),
    };
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchFocusNode.dispose();
    print('Dispose focus node');
    print('Dispose search focus node');
    print("di pause $focusNode");
    print("di pause $searchFocusNode");
    super.onClose();
  }
}