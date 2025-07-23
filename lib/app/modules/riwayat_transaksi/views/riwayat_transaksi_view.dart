import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_transaksi_controller.dart';

class RiwayatTransaksiView extends GetView<RiwayatTransaksiController> {
  const RiwayatTransaksiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RiwayatTransaksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RiwayatTransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
