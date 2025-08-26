import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends StatelessWidget {
  PaymentView({super.key});
  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card saldo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.name.value ?? 'user',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Saldo:",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      "RP. ${controller.saldo.value}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Hutang:",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Text(
                      "-RP. ${controller.hutang.value}",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Total
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "total:",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    "RP. ${controller.totalPembayaran.value}",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Metode pembayaran
            const Text(
              "Metode Pembayaran:",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectMethod("Hutang"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedMethod.value == "Hutang"
                                  ? const Color(0xFF4634CC)
                                  : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Hutang",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectMethod("Saldo"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedMethod.value == "Saldo"
                                  ? const Color(0xFF4634CC)
                                  : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Saldo",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const Spacer(),

            // Tombol bayar
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4634CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  controller.transaksi();
                  debugPrint(
                    "Metode dipilih: ${controller.selectedMethod.value}",
                  );
                },
                child: const Text(
                  "Bayar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
