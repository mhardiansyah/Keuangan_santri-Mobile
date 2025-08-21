import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailRiwayatTransaksiView extends StatelessWidget {
  final Map<String, dynamic> transaksi;

  const DetailRiwayatTransaksiView({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity, // full lebar
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(transaksi['image']),
              ),
              const SizedBox(height: 24),
              _buildRow("Nama:", transaksi['nama']),
              _buildRow("Tanggal Transaksi:", transaksi['tanggal'] ?? "24 Januari 2025"),
              _buildRow("Waktu Beli:", transaksi['waktu'] ?? "13.00 WIB"),
              _buildRow("Jumlah Bayar:", "Rp${transaksi['nominal']}"),
              _buildRow("Status Transaksi:", transaksi['status']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10), // agak lega jaraknya
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
