// ignore_for_file: override_on_non_overriding_member, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/views/product_view.dart';
import 'package:sakusantri/app/modules/cart/views/cart_view.dart';
import 'package:sakusantri/app/modules/history/views/history_view.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import 'package:sakusantri/app/modules/main-navigation/controllers/main_navigation_controller.dart';
import 'package:sakusantri/app/modules/pengaturan_toko/views/pengaturan_toko_view.dart';
import 'package:sakusantri/app/modules/profile/views/profile_view.dart';
import 'package:sakusantri/app/modules/riwayat_transaksi/views/riwayat_transaksi_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

  @override
  final pages = [
    HomeView(),
    CartView(),
    SizedBox(), // Placeholder for Top up
    RiwayatTransaksiView(),
    PengaturanTokoView(),
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
            backgroundColor: Colors.transparent,
            floatingActionButton: SizedBox(
              height: isLandscape ? 50 : 62,
              width: isLandscape ? 50 : 62,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFFFDBD03),
                onPressed: () {
                  controller.focusNode.requestFocus();
                  controller.dialogCek();
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
              color: const Color(0xFF4634CC),
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
                      Icons.shopping_cart,
                      "Checkout",
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
                      Icons.settings,
                      "Pengaturan Toko",
                      4,
                      isLandscape: isLandscape,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Label "Top up" di bawah FAB
          // Positioned(
          //   bottom: isLandscape ? 18 : 20,
          //   left: (screenWidth / 2) - 20,
          //   child: Text(
          //     "Top up",
          //     style: TextStyle(
          //       fontSize: isLandscape ? 10 : 11,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
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

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? const Color(0xFF4634CC) : Colors.white,
                    size: isLandscape ? 22 : 26,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          isSelected ? const Color(0xFF4634CC) : Colors.white,
                      fontSize: isLandscape ? 10 : 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
