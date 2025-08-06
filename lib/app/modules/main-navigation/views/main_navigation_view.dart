// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/views/product_view.dart';
import 'package:sakusantri/app/modules/cart/views/cart_view.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import 'package:sakusantri/app/modules/main-navigation/controllers/main_navigation_controller.dart';
import 'package:sakusantri/app/modules/profile/views/profile_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  // ignore: use_super_parameters
  MainNavigationView({super.key});

  @override
  final pages = [
    HomeView(),
    ProductView(),
    SizedBox(),
    CartView(),
    ProfileView(),
  ];
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            body: pages[controller.selectedIndex.value],
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 62,
                  width: 62,
                  child: FloatingActionButton(
                    shape: CircleBorder(),
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text('Coming Soon'),
                          content: Text(
                            'masih dalam tahap pengembangan untuk fitur ini sabar ya😊🔥🔥🔥',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(Icons.add, size: 42, color: Colors.white),
                  ),
                ),
              ],
            ),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              notchMargin: 8,
              child: Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          _buildNavItem(
                            Icons.home,
                            "Home",
                            0,
                            selectedColor: Colors.orange,
                          ),
                          const SizedBox(width: 22),
                          _buildNavItem(Icons.store, "Toko", 1),
                        ],
                      ),
                    ),

                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildNavItem(Icons.history, "Riwayat", 3),
                          const SizedBox(width: 18),
                          _buildNavItem(Icons.person, "Profile", 4),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Top up",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    Color? selectedColor,
  }) {
    final isSelected = controller.selectedIndex.value == index;
    final color = isSelected ? (selectedColor ?? Colors.orange) : Colors.grey;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
