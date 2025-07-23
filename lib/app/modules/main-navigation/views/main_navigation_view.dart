import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/views/product_view.dart';
import 'package:sakusantri/app/modules/cart/views/cart_view.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import 'package:sakusantri/app/modules/main-navigation/controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  // ignore: use_super_parameters
  MainNavigationView({super.key});

  @override
  final pages = [
    HomeView(),
    ProductView(),
    SizedBox(),
    CartView(),
    Center(child: Text('Profile')),
  ];
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: pages[controller.selectedIndex.value],
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {},
          child: Icon(Icons.add, size: 28, color: Colors.white),
          backgroundColor: Colors.green,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8,
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildNavItem(Icons.home, 'Home', 0),
                    _buildNavItem(Icons.store, 'Toko', 1),
                  ],
                ),
                Row(
                  children: [
                    _buildNavItem(Icons.history, 'History', 3),
                    _buildNavItem(Icons.person, 'Profile', 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = controller.selectedIndex.value == index;
    final color = isSelected ? Colors.orange : Colors.grey;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          // vertical: 8,
        ), // Padding disesuaikan
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            // const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
