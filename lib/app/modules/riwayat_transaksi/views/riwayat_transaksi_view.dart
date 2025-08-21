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
          onPressed: () => Get.off(() => HomeView()),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  hintText: 'Masukkan nama santri',
                  hintStyle: TextStyle(color: Colors.white54),

                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['ALL', 'XII', 'XI', 'X'].map((kelas) {
                  final isSelected = controller.selectedKelas.value == kelas;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: GestureDetector(
                      onTap: () => controller.setKelas(kelas),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              final query = controller.searchQuery.value.toLowerCase();
              final filteredHariIni = controller.transaksiHariIni
                  .where((e) => e['nama'].toString().toLowerCase().contains(query))
                  .toList();

              final filteredKemaren = controller.transaksiKemaren
                  .where((e) => e['nama'].toString().toLowerCase().contains(query))
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildSection("Hari Ini", filteredHariIni),
                  const SizedBox(height: 36),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),

        if (data.isEmpty)
          const Text(
            "Tidak ada data",
            style: TextStyle(color: Colors.white70),
          )
        else
          Column(
            children: data.map((transaksi) {
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(transaksi['image']),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaksi['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaksi['kelas'],
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp${transaksi['nominal']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: transaksi['status'] == 'Lunas'
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            transaksi['status'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: transaksi['status'] == 'Lunas'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
