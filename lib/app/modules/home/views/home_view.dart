// home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/modules/pengaturan_toko/controllers/pengaturan_toko_controller.dart';
import 'package:sakusantri/app/modules/riwayat_hutang/controllers/riwayat_hutang_controller.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<HomeController>(() => HomeController());
    final hutangController = Get.put(RiwayatHutangController());
    final pengaturanTokoController = Get.put(PengaturanTokoController());
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
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.PROFILE),
                    child: CircleAvatar(
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
              // Hero Section
              const SizedBox(height: 56),
              Row(
                children: [
                  // Kartu Total Transaksi
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4634CC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Transaksi Hari ini:",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Text(
                              formatRupiah(
                                controller.totalTransaksiHariIni.value,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    backgroundColor: const Color(0xFF4634CC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.openTarikTunai();
                                  },
                                  icon: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    "Tarik tunai",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    backgroundColor: const Color(0xFF4634CC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.cekSaldo();
                                  },
                                  icon: const Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    "Scan Saldo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Kartu Jam & Tanggal
                  Expanded(
                    flex: 2,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double boxWidth = constraints.maxWidth;

                        double timeFontSize = boxWidth * 0.18;
                        double dateFontSize = boxWidth * 0.065;

                        return Container(
                          height: 160,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1F2C),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.currentTime.value,
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.white,
                                    fontSize: timeFontSize.clamp(20, 60),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Obx(
                                () => Text(
                                  controller.currentDate.value,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: dateFontSize.clamp(12, 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Box Total Produk
              Obx(() {
                if (pengaturanTokoController.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: Color(0xFF1D2938),
                    highlightColor: Color(0xFF101828),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // KIRI
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 80,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: 120,
                                  height: 36,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // KANAN
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                3,
                                (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final habisItems =
                    pengaturanTokoController.itemsList
                        .where((item) => item.jumlah == 0)
                        .map(
                          (item) => {
                            "label": item.nama,
                            "status": "Habis",
                            "color": Colors.red,
                          },
                        )
                        .toList();

                // kalau ada produk habis -> tampilkan list
                // if (habisItems.isNotEmpty) {
                //   return _buildInfoBox(
                //     iconBg: const Color(0xFFCDF6F4),
                //     title: "Total Produk",
                //     value: pengaturanTokoController.itemsList.length.toString(),
                //     items: habisItems,
                //     iconPath: 'assets/icons/kasbon.png',
                //   );
                // }
                return _buildInfoBox(
                  iconBg: const Color(0xFFCDF6F4),
                  title: "Total Produk",
                  value: pengaturanTokoController.itemsList.length.toString(),
                  items: habisItems,
                  iconPath: 'assets/icons/kasbon.png',
                );

                // kalau kosong -> tampilkan teks center
                // return Container(
                //   margin: const EdgeInsets.only(bottom: 16),
                //   padding: const EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF1A1F2C),
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   child: const Center(
                //     child: Text(
                //       "Tidak ada produk kosong ✅",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 14,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ),
                // );
              }),

              const SizedBox(height: 16),

              // Box Total Kasbon
              Obx(() {
                if (hutangController.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: Color(0xFF1D2938),
                    highlightColor: Color(0xFF101828),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F2C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          // Kiri
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 100,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: 120,
                                  height: 22,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: 100,
                                  height: 36,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Kanan
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                2,
                                (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final top2 = hutangController.allSantriList.take(2).toList();
                final totalKasbon = hutangController.allSantriList.fold<int>(
                  0,
                  (sum, e) => sum + (e.hutang ?? 0),
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
                        flex: 2, // 🔥 samain dengan InfoBox
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
                              formatRupiah(totalKasbon),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFC107),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed:
                                  () => Get.toNamed(Routes.RIWAYAT_HUTANG),
                              child: const Text(
                                "Selengkapnya",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20), // 🔥 selaras dengan InfoBox
                      // --- Kanan (Ranking Kasbon Santri)
                      Expanded(
                        flex: 3, // 🔥 samain dengan InfoBox
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
                            const SizedBox(
                              height: 12,
                            ), // 🔥 biar selaras dengan InfoBox
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
          // --- KIRI (Icon, Title, Value, Button)
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
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Get.toNamed(Routes.PENGATURAN_TOKO),
                  child: Text(
                    "Selengkapnya",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),
          if (items != null && items.isEmpty)
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 55),
                    child: Text(
                      "Tidak ada produk kosong di toko ini.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // --- KANAN (Barang Yang Habis)
          if (items != null && items.isNotEmpty)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Barang Yang Habis:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🔥 Scrollable List
                  SizedBox(
                    height: 150, // maksimal tinggi list (bisa lo adjust)
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            items
                                .map(
                                  (item) => Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1F2C),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white30,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item["label"],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            item["status"],
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
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
      width: double.infinity, // 🔥 Lebar penuh seperti InfoBox
      height: 60, // 🔥 lebih kecil (dulu 70)
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

          const Spacer(),

          Text(
            formatRupiah(data.hutang),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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

  String formatRupiah(int amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
}
