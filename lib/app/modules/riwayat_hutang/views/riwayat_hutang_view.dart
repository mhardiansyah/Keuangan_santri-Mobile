import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/riwayat_hutang_controller.dart';

class RiwayatHutangView extends GetView<RiwayatHutangController> {
  const RiwayatHutangView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RiwayatHutangController());

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Riwayat hutang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
      ),
      body: Column(
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
                  hintText: 'Masukkan nama Santri',
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
              final sortedData = controller.sortedByHutang;
              final query = controller.searchQuery.value.toLowerCase();
              final filteredData = sortedData.where((e) {
                final nama = e['nama'].toString().toLowerCase();
                final kelas = controller.selectedKelas.value;
                return nama.contains(query) &&
                    (kelas == "ALL" || e['kelas'] == kelas);
              }).toList();

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  return _buildItem(filteredData[index], index + 1);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> data, int rank) {
    Color badgeColor;
    Widget badgeContent;

    switch (rank) {
      case 1:
        badgeColor = Colors.amber;
        badgeContent = Image.asset('assets/icons/piala.png', width: 24, height: 24);
        break;
      case 2:
        badgeColor = Colors.grey;
        badgeContent = const Text("2", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
        break;
      case 3:
        badgeColor = Colors.brown;
        badgeContent = const Text("3", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
        break;
      default:
        badgeColor = const Color(0xFF4634CC);
        badgeContent = Text(
          rank.toString(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

          CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage(data['image']),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['nama'],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(data['kelas'], style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp${data['nominal']}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "Bayar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
