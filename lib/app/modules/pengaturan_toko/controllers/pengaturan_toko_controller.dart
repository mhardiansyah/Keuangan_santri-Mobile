import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:sakusantri/app/core/models/kategori_model.dart';

class PengaturanTokoController extends GetxController {
  var searchKeyword = ''.obs;
  var url = dotenv.env['base_url'];
  var itemsList = <Items>[].obs;
  var allItems = <Items>[];
  var selectedImage = Rx<File?>(null);
  var kategoriList = <Kategori>[].obs;
  var kategoriId = RxnInt();

  // Controller input pakai obs
  var nama = ''.obs;
  var harga = ''.obs;
  var stok = ''.obs;
  var barcode = ''.obs;

  // Untuk edit
  var editingProduct = Rx<Items?>(null);

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKategori();
    fetchProduct();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> fetchProduct() async {
    try {
      isLoading.value = true;
      var urlItems = Uri.parse("${url}/items");
      final response = await http.get(urlItems);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(response.body);
        final List<dynamic> data = jsonresponse['data'];

        allItems = data.map((item) => Items.fromJson(item)).toList();
        filterProducts();
      } else {
        Get.snackbar('Error', 'Gagal ambil data produk');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed fetch: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts() {
    final keyword = searchKeyword.value.toLowerCase();
    itemsList.assignAll(
      allItems.where((item) => item.nama.toLowerCase().contains(keyword)),
    );
  }

  void openAddDialog() {
    nama.value = "";
    harga.value = "";
    stok.value = "";
    editingProduct.value = null;
    Get.dialog(_buildDialog("Tambah Produk"));
  }

  void openEditDialog(Items product) {
    nama.value = product.nama;
    harga.value = product.harga.toString();
    stok.value = product.jumlah.toString();
    barcode.value = product.barcode.toString();
    editingProduct.value = product;
    kategoriId.value = product.kategoriId;
    selectedImage.value = null; // reset image
    Get.dialog(_buildDialog("Edit Produk"));
  }

  Widget _buildDialog(String title) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white24),
                        ),
                        child:
                            selectedImage.value == null
                                ? const Center(
                                  child: Text(
                                    "Upload Gambar",
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                )
                                : Image.file(
                                  selectedImage.value!,
                                  fit: BoxFit.cover,
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              const SizedBox(height: 12),

              // Input pakai obs
              Obx(
                () => TextField(
                  onChanged: (val) => nama.value = val,
                  decoration: _inputDecoration("Nama Produk"),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: nama.value)
                    ..selection = TextSelection.collapsed(
                      offset: nama.value.length,
                    ),
                ),
              ),
              const SizedBox(height: 12),

              Obx(
                () => TextField(
                  onChanged: (val) => harga.value = val,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Harga Produk"),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: harga.value)
                    ..selection = TextSelection.collapsed(
                      offset: harga.value.length,
                    ),
                ),
              ),
              const SizedBox(height: 12),

              Obx(
                () => TextField(
                  onChanged: (val) => stok.value = val,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Stok Produk"),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: stok.value)
                    ..selection = TextSelection.collapsed(
                      offset: stok.value.length,
                    ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return DropdownButtonFormField<int>(
                  value: kategoriId.value,
                  dropdownColor: const Color(0xFF1E293B),
                  decoration: _inputDecoration("Pilih Kategori"),
                  items:
                      kategoriList.map((kategori) {
                        return DropdownMenuItem<int>(
                          value: kategori.id,
                          child: Text(
                            kategori.nama,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (val) {
                    kategoriId.value = val;
                  },
                );
              }),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              Obx(
                () => TextField(
                  onChanged: (val) => barcode.value = val,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("barcode Produk"),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: barcode.value)
                    ..selection = TextSelection.collapsed(
                      offset: barcode.value.length,
                    ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4634CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<void> saveProduct() async {
    final name = nama.value.trim();
    final price = harga.value.trim();
    final stock = int.tryParse(stok.value) ?? 0;
    final brcode = barcode.value.trim();

    if (name.isEmpty || price.isEmpty) {
      Get.snackbar('Error', 'Nama & Harga tidak boleh kosong');
      return;
    }

    try {
      var uri =
          editingProduct.value == null
              ? Uri.parse("${url}/items/create")
              : Uri.parse("${url}/items/update/${editingProduct.value!.id}");

      var request = http.MultipartRequest(
        editingProduct.value == null ? "POST" : "PUT",
        uri,
      );

      // isi field form
      request.fields['nama'] = name;
      request.fields['harga'] = price;
      request.fields['jumlah'] = stock.toString();
      request.fields['barcode'] = brcode;

      if (kategoriId.value == null) {
        Get.snackbar("Error", "Kategori wajib dipilih");
        return;
      }
      request.fields['kategoriId'] = kategoriId.value.toString();

      // upload file (field = "file", sesuai param di BE kamu)
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar',
            selectedImage.value!.path,
          ),
        );
      }

      var response = await request.send();
      var resBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchProduct();
        Get.back();
        Get.snackbar(
          "Sukses",
          editingProduct.value == null
              ? "Produk berhasil ditambahkan"
              : "Produk berhasil diperbarui",
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar("Error", "Gagal simpan produk: $resBody");
        print('Error: $resBody');
      }
    } catch (e) {
      Get.snackbar("Error", "Request gagal: $e", backgroundColor: Colors.red);
    }
  }

  Future<void> fetchKategori() async {
    try {
      var res = await http.get(
        Uri.parse("${url}/kategori"),
      ); // endpoint kategori
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(res.body);
        final List data = jsonresponse['data'];
        kategoriList.assignAll(data.map((e) => Kategori.fromJson(e)).toList());
        print('result: $data');
      } else {
        Get.snackbar("Error", "Gagal ambil data kategori");
      }
    } catch (e) {
      Get.snackbar("Error", "Fetch kategori gagal: $e");
    }
  }
}
