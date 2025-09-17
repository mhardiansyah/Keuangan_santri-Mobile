import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/riwayat_transaksi_controller.dart';

class RiwayatTransaksiView extends GetView<RiwayatTransaksiController> {
  const RiwayatTransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RiwayatTransaksiController());
    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: 'Masukkan nama Santri',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔘 Filter Kelas
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  ['All', 'XII', 'XI', 'X'].map((kelas) {
                    final isSelected = controller.selectedKelas.value == kelas;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: InkWell(
                        onTap: () => controller.setKelas(kelas),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
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

          // 📋 List Riwayat
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: const Color(0xFF1D2938),
                      highlightColor: const Color(0xFF101828),
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

              if (controller.allHistoryList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async => controller.fetchRiwayatTransaksi(),
                  backgroundColor: Colors.white,
                  color: const Color(0xFF4634CC),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            "Tidak ada data",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => controller.fetchRiwayatTransaksi(),
                backgroundColor: Colors.white,
                color: const Color(0xFF4634CC),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.allHistoryFiltered.length,
                  itemBuilder: (context, index) {
                    final transaksi = controller.allHistoryFiltered[index];
                    return InkWell(
                      onTap:
                          () => Get.toNamed(
                            Routes.DETAIL_RIWAYAT_TRANSAKSI,
                            arguments: transaksi.id,
                          ),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D2938),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: getRandomColor(
                                transaksi.santri.id,
                              ),
                              child: Text(
                                getInitials(transaksi.santri.name),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaksi.santri.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    transaksi.santri.kelas,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat(
                                    "dd MMM yyyy",
                                  ).format(transaksi.createdAt),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        transaksi.status == "Lunas"
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    transaksi.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          transaksi.status == "Lunas"
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String getInitials(String name) {
    if (name.isEmpty) return "";
    final parts = name.split(" ");
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
