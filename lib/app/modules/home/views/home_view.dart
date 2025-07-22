import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

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
                  children: ['Food', 'ATK', 'Sabun'].map((category) {
                  final isSelected =
                    controller.selectedCategory.value == category;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => controller.setCategory(category),
                    selectedColor: Colors.green.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.green : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    showCheckmark: false, // Tidak ada ceklis
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
                    return Center(child: CircularProgressIndicator());
                  }

                  final products = controller.filteredProductList;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            product.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Rp. ${product.price}'),
                          Text('Stock: ${product.stock}'),
                        ],
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
