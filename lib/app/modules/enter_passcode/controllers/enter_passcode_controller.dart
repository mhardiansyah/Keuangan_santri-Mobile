import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class EnterPasscodeController extends GetxController {
  var pin = ''.obs;

  // controller buat Pinput
  final pinController = TextEditingController();

  // state animasi
  var borderColor = const Color(0xFF1E293B).obs;
  var shakeTrigger = false.obs;
  var opacity = 1.0.obs; // untuk fade-out

  // arguments
  var santriId = 0.obs;
  var name = ''.obs;
  var passcode = ''.obs;
  var kelas = ''.obs;
  var saldo = 0.obs;
  var hutang = 0.obs;
  var methodpayment = ''.obs;
  var totalHargaPokok = 0.obs;
  var pajak = 0.obs;
  var totalPembayaran = 0.obs;
  var cartItems = [].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      santriId.value = args['santriId'] ?? 0;
      name.value = args['nama'] ?? '';
      passcode.value = args['passcode'] ?? '';
      kelas.value = args['kelas'] ?? '';
      saldo.value = args['saldo'] ?? 0;
      hutang.value = args['hutang'] ?? 0;
      methodpayment.value = args['method'] ?? '';
      totalHargaPokok.value = args['totalHargaPokok'] ?? 0;
      pajak.value = args['pajak'] ?? 0;
      totalPembayaran.value = args['totalPembayaran'] ?? 0;
      cartItems.assignAll(args['cartItems'] ?? []);
    }
  }

  void resetPin() {
    pin.value = '';
    pinController.clear();
  }

  Future<void> submit() async {
    if (pin.value.length == 6) {
      await Future.delayed(Duration(milliseconds: 500));
      final isvalid = BCrypt.checkpw(pin.value, passcode.value);

      if (isvalid) {
        borderColor.value = const Color(0xFF22C55E);
        await Future.delayed(const Duration(milliseconds: 400));
        Get.toNamed(
          Routes.NOTIF_PEMBAYARAN,
          arguments: {
            'method': methodpayment.value,
            'total': totalPembayaran.value,
            'nama': name.value,
            'santriId': santriId.value,
            'type': TransaksiType.pembayaran,
            'cartItems': cartItems,
            'totalHargaPokok': totalHargaPokok.value,
            'pajak': pajak.value,
            'totalPembayaran': totalPembayaran.value,
            'saldo': saldo.value,
            'hutang': hutang.value,
          },
        );
      } else {
        borderColor.value = const Color(0xFFDC2626);
        shakeTrigger.value = true;

        // Fade-out animasi
        opacity.value = 0.0;
        await Future.delayed(const Duration(milliseconds: 300));
        resetPin();

        // balikin opacity
        opacity.value = 1.0;

        await Future.delayed(const Duration(milliseconds: 500));
        borderColor.value = const Color(0xFF1E293B);
        shakeTrigger.value = false;
      }
    }
  }
}
