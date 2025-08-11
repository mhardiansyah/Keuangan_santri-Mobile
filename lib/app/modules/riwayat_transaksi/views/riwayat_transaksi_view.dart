import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import '../controllers/riwayat_transaksi_controller.dart';

class RiwayatTransaksiView extends GetView<RiwayatTransaksiController> {
  const RiwayatTransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RiwayatTransaksiController());

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => HomeView(),
        ),
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                  hintText: 'Masukkan nama santri',
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filter Kelas
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['XII', 'XI', 'X'].map((kelas) {
                  final isSelected = controller.selectedKelas.value == kelas;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => controller.setKelas(kelas),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4634CC) : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          kelas,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF4634CC),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),

          const SizedBox(height: 16),

          // Transaksi List
          Expanded(
            child: Obx(() {
              // Filter berdasarkan nama dari search bar
              final query = controller.searchQuery.value.toLowerCase();
              final filteredHariIni = controller.transaksiHariIni
                  .where((e) => e['nama'].toString().toLowerCase().contains(query))
                  .toList();

              final filteredKemaren = controller.transaksiKemaren
                  .where((e) => e['nama'].toString().toLowerCase().contains(query))
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSection("Hari Ini", filteredHariIni),
                  const SizedBox(height: 24),
                  _buildSection("Kemaren", filteredKemaren),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (data.isEmpty)
          const Text(
            "Tidak ada data",
            style: TextStyle(color: Colors.white70),
          )
        else
          ...data.map((transaksi) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(transaksi['image']),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaksi['nama'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(transaksi['kelas']),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp${transaksi['nominal']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: transaksi['status'] == 'Lunas' ? Colors.green[100] : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            transaksi['status'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: transaksi['status'] == 'Lunas' ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
      ],
    );
  }
}
