import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_riwayat_transaksi_controller.dart';

class DetailRiwayatTransaksiView
    extends GetView<DetailRiwayatTransaksiController> {
  const DetailRiwayatTransaksiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailRiwayatTransaksiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailRiwayatTransaksiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
