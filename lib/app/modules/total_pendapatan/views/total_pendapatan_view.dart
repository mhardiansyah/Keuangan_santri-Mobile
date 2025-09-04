import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/total_pendapatan_controller.dart';

class TotalPendapatanView extends GetView<TotalPendapatanController> {
  const TotalPendapatanView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TotalPendapatanController());

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        title: const Text(
          'Total Pendapatan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Filter Harian / Mingguan / Bulanan / Tahunan
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'].map((filter) {
                      final isSelected =
                          controller.selectedFilter.value == filter;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap: () => controller.setFilter(filter),
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
                              filter,
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
          ),

          const SizedBox(height: 20),

          // List section (Pagi, Siang, Sore, Malam)
          Expanded(
            child: Obx(() {
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children:
                    controller.pendapatan.keys.map((waktu) {
                      return _buildSection(
                        waktu,
                        controller.pendapatan[waktu]!,
                      );
                    }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header Waktu (Pagi, Siang, dst.)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                  color: const Color(0xFFFFE3C2),
                  shape: BoxShape.circle,
                  ),
                  child: Center(
                  child: Image.asset(
                    "assets/icons/dolars.png",
                    width: 24,
                  ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF0E1220),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Kategori Produk",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Jumlah dibeli",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Total Harga",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Aksi",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Table Body
          Column(
            children:
                data.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.white24, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Kategori (rata kiri)
                        Expanded(
                          flex: 3,
                          child: Text(
                            item['kategori'],
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),

                        // Jumlah (rata tengah)
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${item['jumlah']}",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Harga (rata tengah)
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Rp${item['harga']}",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        // Aksi (ikon sejajar & rata tengah)
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.edit, color: Colors.blue, size: 20),
                              SizedBox(width: 10),
                              Icon(Icons.delete, color: Colors.red, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
