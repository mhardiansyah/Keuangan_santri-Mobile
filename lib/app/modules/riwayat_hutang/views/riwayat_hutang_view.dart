import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/history_transaksi_model.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/riwayat_hutang_controller.dart';

class RiwayatHutangView extends GetView<RiwayatHutangController> {
  const RiwayatHutangView({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller sudah di-inject
    final controller = Get.put(RiwayatHutangController());

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Riwayat Hutang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.white),
                  hintText: 'Masukkan nama Santri',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ),

          // 🎓 Filter kelas
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  ['ALL', 'XII', 'XI', 'X'].map((kelas) {
                    final isSelected = controller.selectedKelas.value == kelas;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                        onTap: () => controller.setKelas(kelas),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF4634CC)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            kelas,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xFF4634CC),
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

          // 📋 List hutang
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                // tampilan shimmer loading
                return ListView.builder(
                  itemCount: 6, // jumlah placeholder shimmer
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: const Color(0xFF1E293B),
                      highlightColor: const Color(0xFF334155),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // baris pertama
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          width: 100,
                                          height: 12,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // baris kedua
                              Container(
                                width: double.infinity,
                                height: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

              final filteredData = controller.filteredSantri;

              filteredData.sort((a, b) => b.hutang.compareTo(a.hutang));

              if (filteredData.isEmpty) {
                return const Center(
                  child: Text(
                    "Data tidak ditemukan",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  final rank = controller.getRank(item);
                  return _buildItem(item, rank);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // 🔖 Card item dengan badge ranking
  Widget _buildItem(Santri data, int rank) {
    Color badgeColor;
    Widget badgeContent;

    switch (rank) {
      case 1:
        badgeColor = Colors.amber;
        badgeContent = const Icon(Icons.emoji_events, color: Colors.white);
        break;
      case 2:
        badgeColor = Colors.grey;
        badgeContent = const Text(
          "2",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
        break;
      case 3:
        badgeColor = Colors.brown;
        badgeContent = const Text(
          "3",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
        break;
      default:
        badgeColor = const Color(0xFF4634CC);
        badgeContent = Text(
          rank.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Badge
          Container(
            width: 50,
            height: 80,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Center(child: badgeContent),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: getRandomColor(data.id),
            child: Text(
              getInitials(data.name),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info Santri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(data.kelas, style: const TextStyle(color: Colors.white70)),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "Bayar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
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
