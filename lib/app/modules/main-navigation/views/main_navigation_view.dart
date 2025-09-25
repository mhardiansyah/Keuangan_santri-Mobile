// ignore_for_file: override_on_non_overriding_member, unused_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/Product/views/product_view.dart';
import 'package:sakusantri/app/modules/cart/views/cart_view.dart';
import 'package:sakusantri/app/modules/history/views/history_view.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import 'package:sakusantri/app/modules/main-navigation/controllers/main_navigation_controller.dart';
import 'package:sakusantri/app/modules/pengaturan_toko/views/pengaturan_toko_view.dart';
import 'package:sakusantri/app/modules/riwayat_transaksi/views/riwayat_transaksi_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

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
    final isDesktop = screenWidth > 800; // batasan desktop

    return Obx(() {
      return Scaffold(
        body: pages[controller.selectedIndex.value],
        backgroundColor: Colors.transparent,

        // FAB (Tombol Top Up)
        floatingActionButton: SizedBox(
          height: isLandscape ? 50 : (isDesktop ? 70 : 62),
          width: isLandscape ? 50 : (isDesktop ? 70 : 62),
          child: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFFFDBD03),
            onPressed: () {
              controller.focusNode.requestFocus();
              controller.dialogCek();
            },
            child: Icon(
              Icons.add,
              size: isLandscape ? 30 : (isDesktop ? 40 : 36),
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // Bottom Navbar
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: const Color(0xFF4634CC),
          child: Container(
            height: isDesktop ? 85 : (isLandscape ? 60 : 70),
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 30 : 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  Icons.home,
                  "Home",
                  0,
                  isLandscape: isLandscape,
                  isDesktop: isDesktop,
                ),
                _buildNavItem(
                  Icons.shopping_cart,
                  "Checkout",
                  1,
                  isLandscape: isLandscape,
                  isDesktop: isDesktop,
                ),
                const SizedBox(width: 40), // space untuk FAB (Top Up)
                _buildNavItem(
                  Icons.history,
                  "Riwayat",
                  3,
                  isLandscape: isLandscape,
                  isDesktop: isDesktop,
                ),
                _buildNavItem(
                  Icons.settings,
                  "Pengaturan",
                  4,
                  isLandscape: isLandscape,
                  isDesktop: isDesktop,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool isLandscape = false,
    bool isDesktop = false,
  }) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: Container(
        width: isDesktop ? 90 : 75,
        height: isDesktop ? 90 : 75,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF4634CC) : Colors.white,
                size: isDesktop ? 26 : (isLandscape ? 20 : 22),
              ),
              const SizedBox(height: 3),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          isSelected ? const Color(0xFF4634CC) : Colors.white,
                      fontSize: isDesktop ? 12 : (isLandscape ? 9 : 10),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
