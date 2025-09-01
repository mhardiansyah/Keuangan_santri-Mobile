import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sakusantri/app/core/models/kategori_model.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var selectedCategory = ''.obs;
  var searchKeyword = ''.obs;
  var itemsList = <Items>[].obs;
  var kategoriList = <Kategori>[].obs;

  List<Items> allItems = [];
  var url = dotenv.env['base_url'];

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
    // fetchKategori();
  }

  void fetchProduct() async {
    isLoading.value = true;

    try {
      var urlItems = Uri.parse("${url}/items");
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

  void fetchKategori() async {
    var urlKategori = Uri.parse("${url}/kategori");
    try {
      final response = await http.get(urlKategori);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(response.body);
        final List<dynamic> data = jsonresponse['data'];
        kategoriList.assignAll(
          data.map((item) => Kategori.fromJson(item)).toList(),
        );
        print('result: $data');
      } else {
        print("Failed to fetch categories");
      }
    } catch (e) {
      print("error: $e");
    }
  }

  void filterProducts() {
    final keyword = searchKeyword.value.toLowerCase();
    final kategori = selectedCategory.value.toLowerCase();

    itemsList.assignAll(
      allItems.where((item) {
        // final machtkeyword = item.nama.toLowerCase().contains(keyword);
        final machtkeyword = (item.nama ?? '').toLowerCase().contains(keyword);
        final matchKategori =
            kategori.isEmpty || item.kategoriId.toString() == kategori;
        return machtkeyword && matchKategori;
      }),
    );
  }

  void setCategory(String kategori) {
    selectedCategory.value = kategori;
    filterProducts();
  }

  void searchProduct(String keyword) {
    searchKeyword.value = keyword;
    filterProducts();
  }
}
