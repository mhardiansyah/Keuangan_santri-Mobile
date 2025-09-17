import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class MainNavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var cardInput = ''.obs;
  var cardUID = ''.obs;
  var santriName = "N/A".obs;
  var santriKelas = "N/A".obs;
  var santriSaldo = 0.obs;
  var santriHutang = 0.obs;
  var santri = Rxn<Santri>();
  var kartu = Rxn<Kartu>();
  var santriId = 0.obs;
  var url = dotenv.env['base_url'];

  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    print('url dari env: $url');
    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
    });
  }

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      if (key == 'Enter') {
        final uid = cardInput.value.trim();
        cardUID.value = uid;
        cardInput.value = '';
        getSantriByUID(uid);
      } else {
        cardInput.value += key;
      }
    }
    return KeyEventResult.handled;
  }

  void dialogCek() {
    print('url dari env: $url');
    santri.value = null; // reset dulu
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Focus(
          focusNode: focusNode,
          onKeyEvent: (node, event) => onKeyEvent(node, event),
          child: Obx(() {
            final data = santri.value;
            return Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 200,
                maxWidth: Get.width * 0.6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xff1D2938),
                borderRadius: BorderRadius.circular(16),
                image:
                    data != null
                        ? const DecorationImage(
                          image: AssetImage("assets/images/Card santri.png"),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 350,
                      vertical: 50,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (data == null) ...[
                          Image.asset("assets/icons/tapKartu.png", width: 60),
                          const SizedBox(height: 16),
                          const Text(
                            "Silahkan Tap kartu anda...",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          const SizedBox(height: 16),
                          Text(
                            "Saldo ${data.name} tersisa:",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            formatRupiah(data.saldo),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Tombol close
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xff4F39F6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      barrierDismissible: false, // sama kaya kode 2
    ).then((_) => Get.until((route) => !Get.isDialogOpen!));

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  void resetInput() {
    cardInput.value = '';
    cardUID.value = '';
    santri.value = null;
    santriName.value = "N/A";
    santriKelas.value = "N/A";
    santriSaldo.value = 0;
    santriHutang.value = 0;
  }

  void getSantriByUID(String nomor_kartu) async {
    print('kartu yang di tap $nomor_kartu');

    // Kosongkan dulu supaya UI direset
    santri.value = null;
    santri.refresh();

    Uri urlHome = Uri.parse(
      "$url/kartu",
    ).replace(queryParameters: {'noKartu': nomor_kartu});

    try {
      final response = await http.get(
        urlHome,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          final kartu = Data.fromJson(data);
          santri.value = kartu.santri;
          _updateSanriData(kartu.santri);
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 150),
                decoration: BoxDecoration(
                  color: const Color(0xff1D2938),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icons/kartucek.png",
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kartu di temukan",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );
          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
            Get.toNamed(
              Routes.NOMINAL,
              arguments: {
                "santriId": kartu.santri?.id,
                "nama": kartu.santri?.name,
                "type": TransaksiType.topUp,
              },
            );
          });
        } else {
          Get.snackbar('Info', 'Kartu tidak ditemukan');
        }
      }
    } catch (e) {
      santri.value = null;
      print('Error getSantriByUID: $e');
    }
  }

  void _updateSanriData(Santri santriData) {
    santriName.value = santriData.name ?? "N/A";
    santriKelas.value = santriData.kelas ?? "N/A";
    santriSaldo.value = santriData.saldo ?? 0;
    santriHutang.value = santriData.hutang ?? 0;
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
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
