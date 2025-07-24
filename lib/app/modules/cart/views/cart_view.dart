import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CartView'), centerTitle: true),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text(item.product.nama),
                    subtitle: Text('Rp. ${item.product.harga}'),
                    trailing: IconButton(
                      onPressed: () => controller.removeCart(item.product),
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  controller.clear();
                },
                child: const Text('Checkout'),
              ),
            ),
          ],
        );
      }),
    );
  }
}
