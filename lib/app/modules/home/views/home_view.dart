// home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/modules/riwayat_hutang/controllers/riwayat_hutang_controller.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<HomeController>(() => HomeController());
    final hutangController = Get.put(RiwayatHutangController());
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
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
                  CircleAvatar(
                    backgroundColor: getRandomColor(0),
                    radius: 20,
                    child: Text(
                      getInitials(username),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello $username',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xFF4634CC),
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.NOTIFIKASI);
                    },
                    icon: const Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Card Penjualan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4634CC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Penjualan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'RP. 10.000.000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 33),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        SizedBox(
                          width: isLandscape ? (screenWidth * 0.4) - 40 : 142,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.openTarikTunai();
                              controller.focusNode.requestFocus();
                            },
                            icon: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Tarik saldo',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4634CC),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: isLandscape ? (screenWidth * 0.4) - 40 : 142,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.cekSaldo();
                              controller.focusNode.requestFocus();
                            },
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Scan card',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4634CC),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Box Total Transaksi
              // _buildInfoBox(
              //   iconBg: const Color(0xFFFFE3C2),
              //   title: "Total Transaksi",
              //   value: "Rp.20jt",
              //   items: [
              //     {
              //       "label": "Transaksi Pagi",
              //       "status": "Lihat",
              //       "color": Colors.green,
              //     },
              //     {
              //       "label": "Transaksi Siang",
              //       "status": "Lihat",
              //       "color": Colors.green,
              //     },
              //     {
              //       "label": "Transaksi Malam",
              //       "status": "Lihat",
              //       "color": Colors.green,
              //     },
              //   ],
              //   iconPath: 'assets/icons/kasbon.png',
              // ),
              // const SizedBox(height: 16),

              // Box Total Produk
              _buildInfoBox(
                iconBg: const Color(0xFFCDF6F4),
                title: "Total Produk",
                value: "12",
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
                iconPath: 'assets/icons/kasbon.png',
              ),
              const SizedBox(height: 16),

              // Box Total Kasbon
              Obx(() {
                final top2 = hutangController.allSantriList.take(2).toList();
                final totalKasbon = hutangController.allSantriList.fold<int>(
                  0,
                  (sum, e) => sum + (e.hutang),
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F2C),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // --- Kiri (Total Kasbon)
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFF5C3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/kasbon.png',
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Total Kasbon",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Rp ${totalKasbon}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                // Tambahkan logika untuk "Selengkapnya"
                                Get.toNamed(Routes.RIWAYAT_HUTANG);
                              },
                              child: const Text(
                                "Selengkapnya",
                                style: TextStyle(
                                  color: Color(0xFFFBC02D),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // --- Kanan (Ranking Kasbon Santri)
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ranking Kasbon Santri",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...top2.map((santri) {
                              final rank = top2.indexOf(santri) + 1;
                              return _buildRankingKasbon(
                                index: rank - 1,
                                data: santri,
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- reusable box widget ---
  Widget _buildInfoBox({
    required String title,
    required String value,
    required String iconPath,
    required Color iconBg,
    List<Map<String, dynamic>>? items,
    List<Map<String, dynamic>>? ranking,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Kiri (Icon, title, value, selengkapnya)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(iconPath, width: 22, height: 22),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    "Selengkapnya",
                    style: TextStyle(
                      color: Color(0xFFFBC02D),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Kanan (items atau ranking)
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
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFFFFF)),
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
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (item["color"] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item["status"],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: item["color"],
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: const AssetImage(
                              "assets/icons/logo.png",
                            ),
                            backgroundColor: Colors.grey[300],
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

  Widget _buildRankingKasbon({required int index, required Santri data}) {
    final bool isTop1 = index == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 60, // 🔥 lebih kecil (dulu 70)
      width: double.infinity, // 🔥 biar panjang full
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          // --- Badge Rank
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: isTop1 ? Colors.amber : Colors.grey[700],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child:
                  isTop1
                      ? const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 20,
                      )
                      : Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),

          const SizedBox(width: 12),

          // --- Avatar
          CircleAvatar(
            radius: 18, // 🔥 diperkecil biar pas sama height baru
            backgroundColor: getRandomColor(data.id),
            child: Text(
              getInitials(data.name),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),

          const SizedBox(width: 12),

          // --- Info Santri
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  data.kelas,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.split(" ");
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  Color getRandomColor(int seed) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
    ];
    return colors[seed % colors.length];
  }
}