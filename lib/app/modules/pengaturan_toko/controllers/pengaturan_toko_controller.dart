import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Product {
  String name;
  String price;
  int stock;
  String? image;

  Product({
    required this.name,
    required this.price,
    required this.stock,
    this.image,
  });
}

class PengaturanTokoController extends GetxController {
  var products = <Product>[].obs;

  // form field controllers
  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();

  Rx<Product?> editingProduct = Rx<Product?>(null);

  @override
  void onInit() {
    super.onInit();

    // ✅ Dummy data awal
    products.addAll([
      Product(
        name: "Sosis Kimbo",
        price: "Rp6000",
        stock: 20,
        image:
            "https://images.tokopedia.net/img/cache/700/product-1/2020/9/28/10045754/10045754_b1f14f86-fb25-4542-9c40-12d01d7c1849.jpg",
      ),
      Product(
        name: "Sosis Sonice",
        price: "Rp6000",
        stock: 2,
        image:
            "https://images.tokopedia.net/img/cache/700/VqbcmM/2021/4/22/8fa05c8c-7273-4c83-ae02-b9b40b84bd53.jpg",
      ),
    ]);
  }

  void openAddDialog() {
    namaController.clear();
    hargaController.clear();
    stokController.clear();
    editingProduct.value = null;
    Get.dialog(_buildDialog("Tambah Barang"));
  }

  void openEditDialog(Product product) {
    namaController.text = product.name;
    hargaController.text = product.price;
    stokController.text = product.stock.toString();
    editingProduct.value = product;
    Get.dialog(_buildDialog("Edit Barang"));
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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Nama
              TextField(
                controller: namaController,
                decoration: _inputDecoration("Nama Barang"),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Harga
              TextField(
                controller: hargaController,
                decoration: _inputDecoration("Harga Barang"),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Stok
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Stok Produk"),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),

              // Upload Foto Produk (dummy)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Upload png/jpg",
                        style: TextStyle(color: Colors.white70)),
                    Icon(Icons.upload, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Simpan Button
              GestureDetector(
                onTap: saveProduct,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4634CC),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Simpan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              )
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

  void saveProduct() {
    final name = namaController.text;
    final price = hargaController.text;
    final stock = int.tryParse(stokController.text) ?? 0;

    if (editingProduct.value == null) {
      // Tambah
      products.add(Product(name: name, price: price, stock: stock));
    } else {
      // Edit
      final product = editingProduct.value!;
      product.name = name;
      product.price = price;
      product.stock = stock;
      products.refresh();
    }

    Get.back();
  }
}
