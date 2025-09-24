// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/history_transaksi_model.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:sakusantri/app/modules/detail_riwayat_transaksi/controllers/detail_riwayat_transaksi_controller.dart';
import 'package:sakusantri/app/modules/pengaturan_toko/controllers/pengaturan_toko_controller.dart';

class DetailRiwayatTransaksiView
    extends GetView<DetailRiwayatTransaksiController> {
  const DetailRiwayatTransaksiView({super.key});

  @override
  Widget build(BuildContext context) {
    final tokoController = Get.find<PengaturanTokoController>();
    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Riwayat",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final transaksi = controller.historydetail.value;
        if (transaksi == null) {
          return const Center(
            child: Text(
              "Tidak ada detail",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1D2938),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: getRandomColor(transaksi.santri.id),
                    child:
                        getInitials(transaksi.santri.name) != ""
                            ? Text(
                              getInitials(transaksi.santri.name),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRow("Nama:", transaksi.santri.name),
                _buildRow(
                  "Tanggal Transaksi:",
                  DateFormat('dd MMMM yyyy').format(transaksi.createdAt),
                ),
                _buildRow(
                  "Waktu Beli:",
                  DateFormat('HH:mm').format(transaksi.createdAt) + " WIB",
                ),
                _buildRow("Jumlah Bayar:", "Rp${transaksi.totalAmount}"),
                const SizedBox(height: 10),
                const Text(
                  "Barang Yang Dibeli:",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 6),

                // 🔥 Loop items
                ...transaksi.items.map((item) {
                  final foundItem = tokoController.allItems.firstWhere(
                    (e) => e.id == item.itemId,
                  );

                  return Text(
                    "• ${foundItem.nama} x${item.quantity} (Rp${item.priceAtPurchase})",
                    style: const TextStyle(color: Colors.white),
                  );
                }),

                const SizedBox(height: 6),
                _buildRow("Jumlah Yang Dibeli:", "${transaksi.items.length}"),
                _buildRow("Status Transaksi:", transaksi.status),
              ],
            ),
          ),
        );
      }),
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
