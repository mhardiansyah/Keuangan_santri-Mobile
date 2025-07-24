import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/cart/controllers/cart_controller.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  ProductView({super.key});
  get controllercart => Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: controller.searchProduct,
                        decoration: InputDecoration(
                          hintText: 'Cari produk',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      // TODO: Implement keranjang/cart action
                      Get.toNamed('/cart');
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(Icons.shopping_cart, color: Colors.green),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Category filter
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      ['Semua', 'makanan', 'ATK', 'Sabun'].map((kategori) {
                        final isSelected =
                            controller.selectedCategory.value ==
                            (kategori == 'Semua' ? '' : kategori);
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => controller.setCategory(kategori),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                kategori,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.green : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),

              SizedBox(height: 16),

              // Product Grid
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 280,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 16,
                                width: double.infinity,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 14,
                                width: 100,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                height: 14,
                                width: 60,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  final products =
                      controller.itemsList
                          .where(
                            (product) =>
                                controller.selectedCategory.value.isEmpty ||
                                product.kategori.toLowerCase() ==
                                    controller.selectedCategory.value
                                        .toLowerCase(),
                          )
                          .toList();
                  return GridView.builder(
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar Produk di bagian atas (ungu)
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[100],
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  product.gambar,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) => Center(
                                        child: Icon(Icons.broken_image),
                                      ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.nama,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Rp. ${product.harga}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    'Stock: ${product.jumlah}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        controllercart.addCart(product);
                                        Get.toNamed('/cart');
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
