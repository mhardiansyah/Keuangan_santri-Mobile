import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/modules/home/controllers/home_controller.dart';
import 'package:sakusantri/app/modules/pengaturan_toko/controllers/pengaturan_toko_controller.dart';
import 'package:sakusantri/app/modules/riwayat_hutang/controllers/riwayat_hutang_controller.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import '../controllers/notif_pembayaran_controller.dart';

class NotifPembayaranView extends GetView<NotifPembayaranController> {
  const NotifPembayaranView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final pengaturanTokoController = Get.find<PengaturanTokoController>();
    final riwayatHutangController = Get.find<RiwayatHutangController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.offAllNamed(Routes.MAIN_NAVIGATION),
        ),
        title: Obx(() {
          String title = "";

          if (controller.transaksiType.value == TransaksiType.pembayaran) {
            title = "Pembayaran";
          } else if (controller.transaksiType.value ==
              TransaksiType.tarikTunai) {
            title = "Tarik Tunai";
          } else if (controller.transaksiType.value == TransaksiType.topUp) {
            title = "Top Up";
          }

          return Text(title, style: TextStyle(color: Colors.white));
        }),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          String successText = "";
          String labelTotal = "";
          bool showMethod = false;

          if (controller.transaksiType.value == TransaksiType.pembayaran) {
            successText = "Pembayaran Berhasil";
            labelTotal = "Total Harga:";
            showMethod = true;
          } else if (controller.transaksiType.value ==
              TransaksiType.tarikTunai) {
            successText = "Tarik Tunai Berhasil";
            labelTotal = "Total Tarik Tunai";
            showMethod = true;
          } else if (controller.transaksiType.value == TransaksiType.topUp) {
            successText = "Top Up Berhasil";
            labelTotal = "Total Top Up";
            showMethod = true;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/icons/success.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                successText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Detail Transaksi",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2230),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Nama:",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          controller.santriName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          labelTotal,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatRupiah(controller.totalHarga.value),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (showMethod) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Metode pembayaran:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            controller.selectedMethod.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B3FFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () async {
                    Get.offAllNamed(Routes.MAIN_NAVIGATION);
                    await controller.checkout(controller.santriId.value);
                    await homeController.fechtTotalTransaksiHariIni();
                    await pengaturanTokoController.fetchProduct();
                    await riwayatHutangController.fetchRiwayatTransaksi();
                    Get.snackbar(
                      "Tersimpan",
                      "Data transaksi berhasil disimpan",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  child: const Text(
                    "Selesai",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
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
