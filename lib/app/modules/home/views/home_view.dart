// home_view.dart
// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/home_controller.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<HomeController>(() => HomeController());
    final box = GetStorage();
    final username = box.read('name') ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/icons/logo.png'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello $username",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      onPressed: () => Get.toNamed(Routes.NOTIFIKASI),
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Saldo Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5A47E5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Saldo hari ini",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "RP. 10.000.000",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.money,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              "Tarik tunai",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              "Scan Saldo",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Box Total Transaksi
              _buildInfoBox(
                imagePath: "assets/icons/dolars.png",
                iconBg: const Color(0xFFFFE3C2),
                title: "Total Transaksi",
                value: "Rp.20jt",
                actionText: "",
                items: [
                  {
                    "label": "Transaksi Pagi",
                    "status": "Lihat",
                    "color": Colors.green,
                  },
                  {
                    "label": "Transaksi Siang",
                    "status": "Lihat",
                    "color": Colors.green,
                  },
                  {
                    "label": "Transaksi Malam",
                    "status": "Lihat",
                    "color": Colors.green,
                  },
                ],
              ),

              const SizedBox(height: 16),

              // Box Total Produk
              _buildInfoBox(
                imagePath: "assets/icons/kardus.png",
                iconBg: const Color(0xFFCDF6F4),
                title: "Total Produk",
                value: "12",
                actionText: "",
                items: [
                  {
                    "label": "Roti Aoka Keju",
                    "status": "Habis",
                    "color": Colors.red,
                  },
                  {
                    "label": "Milku Stroberi",
                    "status": "Habis",
                    "color": Colors.red,
                  },
                ],
              ),

              const SizedBox(height: 16),

              // Box Total Kasbon
              _buildInfoBox(
                imagePath: "assets/icons/kasbon.png",
                iconBg: const Color(0xFFFFF5C3),
                title: "Total Kasbon",
                value: "300K",
                actionText: "",
                ranking: [
                  {"name": "Muhammad Dafleng", "kelas": "XII"},
                  {"name": "Muhammad Dafleng", "kelas": "XII"},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- reusable box widget ---
  Widget _buildInfoBox({
    String? imagePath,
    Color? iconBg,
    required String title,
    required String value,
    required String actionText,
    List<Map<String, dynamic>>? items,
    List<Map<String, dynamic>>? ranking,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(imagePath!, width: 24, height: 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    if (title == "Total Transaksi") {
                      Get.toNamed(Routes.TOTAL_PENDAPATAN);
                    } else if (title == "Total Produk") {
                      Get.toNamed(Routes.PENGATURAN_TOKO);
                    } else if (title == "Total Kasbon") {
                      Get.toNamed(Routes.RIWAYAT_HUTANG);
                    }
                  },
                  child: const Text(
                    "Selengkapnya",
                    style: TextStyle(
                      color: Color(0xFFFBC02D),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right side
          Expanded(
            flex: 2,
            child: Column(
              children: [
                if (items != null)
                  ...items.map(
                    (item) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2F3C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item["label"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (item["color"] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item["status"],
                              style: TextStyle(
                                fontSize: 12,
                                color: item["color"],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (ranking != null)
                  ...ranking.map(
                    (rank) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2F3C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(
                              'assets/icons/logo.png',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              rank["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            rank["kelas"],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}