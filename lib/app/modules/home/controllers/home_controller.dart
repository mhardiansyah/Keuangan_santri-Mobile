// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/login_model.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/core/models/items_model.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var itemsList = <Items>[].obs;
  var cardInput = ''.obs;
  var cardUID = ''.obs;
  var santri = Rxn<Santri>();
  var kartu = Rxn<Kartu>();
  var url = dotenv.env['base_url'];
  var isScanning = false.obs;
  final box = storage.GetStorage();

  var santriName = "N/A".obs;
  var santriKelas = "N/A".obs;
  var santriSaldo = 0.obs;
  var santriHutang = 0.obs;

  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
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
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Focus(
          focusNode: focusNode,
          onKeyEvent: (node, event) => onKeyEvent(node, event),
          child: Container(
            // padding: const EdgeInsets.all(20),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 150),
            decoration: BoxDecoration(
              color: Color(0xff1D2938),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Obx(() {
              final data = santri.value;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (data == null) ...[
                          Image.asset(
                            "assets/icons/tapKartu.png",
                            width: 60,
                            height: 60,
                          ),
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
                            "Rp${data.saldo ?? 0}",
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
              );
            }),
          ),
        ),
      ),
      barrierDismissible: true,
    ).then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        resetInput();
      });
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
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
        if (jsonResponse['data'] is List) {
          final dataList = jsonResponse['data'] as List;

          final match = dataList.firstWhere(
            (item) => item['nomorKartu'] == nomor_kartu,
            orElse: () => null,
          );

          if (match != null) {
            final kartu = Data.fromJson(match);
            santri.value = kartu.santri;
            santri.refresh();
            _updateSanriData(kartu.santri);
            return;
          }

          Get.snackbar('Info', 'Kartu tidak ditemukan');
        }
      } else {
        santri.value = null;
        Get.snackbar('Error', 'Gagal mengambil data.');
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
}
