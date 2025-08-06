import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/cart/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controllercart = Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      //AppBar disamakan seperti halaman Profile
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Toko',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
      ),

      //Bottom cart bar jika ada item
      bottomNavigationBar: Obx(() {
        if (controllercart.cartItems.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Text(
                '${controllercart.cartItems.length} Item dipilih',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed('/cart'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFACC15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_cart, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: controller.searchProduct,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Masukan nama Item',
                    hintStyle: TextStyle(color: Colors.white54),
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //Kategori
              Obx(() {
                final kategoriList = ['Makanan', 'Minuman', 'Alat Tulis'];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: kategoriList.map((kategori) {
                    final selected =
                        controller.selectedCategory.value == kategori;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GestureDetector(
                        onTap: () => controller.setCategory(kategori),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF6366F1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kategori,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 16),

              //Grid Produk
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final products = controller.itemsList.where(
                    (product) {
                      final selected = controller.selectedCategory.value;
                      return selected.isEmpty ||
                          product.kategori.toLowerCase() ==
                              selected.toLowerCase();
                    },
                  ).toList();

                  return GridView.builder(
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.60,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Gambar produk
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.gambar,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              product.nama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Tersedia',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rp${product.harga}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),

                            //Tombol tambah ke keranjang
                            Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () {
                                  controllercart.addCart(product);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFACC15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.add,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
