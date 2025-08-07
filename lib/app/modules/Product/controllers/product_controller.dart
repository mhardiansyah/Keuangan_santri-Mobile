import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:http/http.dart' as http;

// class Product {
//   final String name;
//   final int price;
//   final int stock;
//   final String category;

//   Product({
//     required this.name,
//     required this.price,
//     required this.stock,
//     required this.category,
//   });
// }

class ProductController extends GetxController {
  var isLoading = true.obs;
  var selectedCategory = ''.obs;
  var searchKeyword = ''.obs;
  var itemsList = <Items>[].obs;
  List<Items> allItems = [];

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
  }

  void fetchProduct() async {
    isLoading.value = true;

    try {
      var urlItems = Uri.parse("http://10.0.2.2:5000/items");
      final response = await http.get(urlItems);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(response.body);
        print(json.decode(response.body));

        final List<dynamic> data = jsonresponse['data'];
        print(data);

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
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts() {
    final keyword = searchKeyword.value.toLowerCase();
    final kategori = selectedCategory.value.toLowerCase();

    itemsList.assignAll(
      allItems.where((item) {
        final machtkeyword = item.nama.toLowerCase().contains(keyword);
        final matchkategori =
            kategori.isEmpty || item.kategoriId.toString() == kategori;
        return machtkeyword && matchkategori;
      }),
    );
  }

  void setCategory(String kategori) {
    selectedCategory.value = kategori == 'Semua' ? '' : kategori;
    filterProducts();
  }

  void searchProduct(String keyword) {
    searchKeyword.value = keyword;
    filterProducts();
  }
}
