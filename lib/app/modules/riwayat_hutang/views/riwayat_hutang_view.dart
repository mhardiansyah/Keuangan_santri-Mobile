// ignore_for_file: unnecessary_cast, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/riwayat_hutang_controller.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';

class RiwayatHutangView extends GetView<RiwayatHutangController> {
  const RiwayatHutangView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Riwayat Hutang",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Column(
            children: [
              // 🔍 Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2433),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    onChanged: controller.setSearchQuery,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white54, size: 22),
                      hintText: 'Masukan nama Santri',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔘 Filter kelas
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['Semua', 'X', 'XI', 'XII'].map((kelas) {
                    final isSelected = controller.selectedKelas.value == kelas;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => controller.setKelas(kelas),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF5C4BFF) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kelas,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF5C4BFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // 📋 List Hutang
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: const Color(0xFF1D2938),
                          highlightColor: const Color(0xFF2A364B),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  final filtered = controller.filteredSantri;
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "Tidak ada data hutang",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final santri = filtered[index];
                      final rank = controller.getRank(santri);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2433),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            // 🏅 Rank Box
                            Container(
                              width: 55,
                              height: 80,
                              decoration: BoxDecoration(
                                color: getRankColor(rank),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: rank == 1
                                    ? const Icon(Icons.emoji_events,
                                        color: Colors.white, size: 26)
                                    : Text(
                                        rank.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // 👤 Inisial Nama Santri
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: getRandomColor(santri.id),
                              child: Text(
                                getInitials(santri.name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // 🧾 Nama dan Kelas
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    santri.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    santri.kelas,
                                    style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

          // Nominal + Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatRupiah(data.hutang),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Container(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 12,
              //     vertical: 6,
              //   ),
              //   decoration: BoxDecoration(
              //     color: Colors.red[200],
              //     borderRadius: BorderRadius.circular(14),
              //   ),
              //   child: const Text(
              //     "Bayar",
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: Colors.white,
              //       fontSize: 12,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  // 🏅 Warna Rank
  Color getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFC300);
      case 2:
        return const Color(0xFFBFBFBF);
      case 3:
        return const Color(0xFFB87333);
      default:
        return const Color(0xFF5C4BFF);
    }
  }

  // 💵 Format Rupiah
  String formatRupiah(int amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatCurrency.format(amount);
  }

  // 🧍 Fungsi Inisial Nama
  String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return "?";
    final parts = name.trim().split(" ").where((p) => p.isNotEmpty).toList();

    if (parts.isEmpty) return "?";
    if (parts.length == 1) {
      final first = parts[0];
      return first.substring(0, first.length >= 2 ? 2 : 1).toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  // 🎨 Warna Random Berdasarkan ID Santri
  Color getRandomColor(dynamic seed) {
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

    if (seed == null) return Colors.grey;
    final seedValue = seed.hashCode.abs();
    return colors[seedValue % colors.length];
  }
}
