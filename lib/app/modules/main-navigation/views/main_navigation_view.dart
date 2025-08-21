// ignore_for_file: override_on_non_overriding_member, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/views/product_view.dart';
import 'package:sakusantri/app/modules/cart/views/cart_view.dart';
import 'package:sakusantri/app/modules/history/views/history_view.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import 'package:sakusantri/app/modules/main-navigation/controllers/main_navigation_controller.dart';
import 'package:sakusantri/app/modules/profile/views/profile_view.dart';
import 'package:sakusantri/app/modules/riwayat_transaksi/views/riwayat_transaksi_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

  @override
  final pages = [
    HomeView(),
    ProductView(),
    SizedBox(), // Placeholder for Top up
    RiwayatTransaksiView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            body: pages[controller.selectedIndex.value],
            backgroundColor: const Color(0xFF0E1220),
            floatingActionButton: SizedBox(
              height: isLandscape ? 50 : 62,
              width: isLandscape ? 50 : 62,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: const Color(
                  0xFFFDBD03,
                ), // Warna kuning sesuai desain
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text('This feature is under development.'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Icon(
                  Icons.add,
                  size: isLandscape ? 30 : 36,
                  color: Colors.white,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              color: const Color(0xFF4634CC), // Warna ungu utama sesuai desain
              child: Container(
                height: isLandscape ? 60 : 70,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(
                      Icons.home,
                      "Home",
                      0,
                      isLandscape: isLandscape,
                    ),
                    _buildNavItem(
                      Icons.store,
                      "Toko",
                      1,
                      isLandscape: isLandscape,
                    ),
                    const SizedBox(width: 40), // Space for FAB
                    _buildNavItem(
                      Icons.history,
                      "Riwayat",
                      3,
                      isLandscape: isLandscape,
                    ),
                    _buildNavItem(
                      Icons.person,
                      "Profile",
                      4,
                      isLandscape: isLandscape,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Label "Top up" di bawah FAB
          Positioned(
            bottom: isLandscape ? 18 : 20,
            left: (screenWidth / 2) - 20,
            child: Text(
              "Top up",
              style: TextStyle(
                fontSize: isLandscape ? 10 : 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
    bool isLandscape = false,
  }) {
    final isSelected = controller.selectedIndex.value == index;
    final color = isSelected ? Colors.white : Colors.white70;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isLandscape ? 22 : 26),
            const SizedBox(height: 4),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: isLandscape ? 10 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
