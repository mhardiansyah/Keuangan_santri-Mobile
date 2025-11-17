// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/history_transaksi_model.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class HomeController extends GetxController {
  // Observables
  var isLoading = true.obs;
  var itemsList = <Items>[].obs;
  var cardInput = ''.obs;
  var cardUID = ''.obs;
  var santri = Rxn<Santri>();
  var kartu = Rxn<Kartu>();
  var isScanning = false.obs;
  var currentMode = "Tarik-tunai".obs;
  var totalTransaksiHariIni = 0.obs;

  // Santri info
  var santriName = "N/A".obs;
  var santriKelas = "N/A".obs;
  var santriSaldo = 0.obs;
  var santriHutang = 0.obs;

  // Utils
  final box = storage.GetStorage();
  final focusNode = FocusNode();
  final baseUrl = dotenv.env['base_url'];
  Timer? _timer;
  var currentTime = ''.obs;
  var currentDate = ''.obs;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTime();
    });
    Future.delayed(Duration.zero, () => focusNode.requestFocus());
    fechtTotalTransaksiHariIni();
  }

  void updateTime() {
    final now = DateTime.now();
    currentTime.value = DateFormat('HH:mm:ss').format(now);
    currentDate.value = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);
  }

  /// Handler input kartu via keyboard
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        final uid = cardInput.value.trim();

        if (isScanning.value) {
          cardInput.value = '';
          return KeyEventResult.handled;
        }
        cardUID.value = uid;
        cardInput.value = '';

        if (currentMode.value == 'Tarik-tunai') {
          _fetchSantri(uid, withTarikSaldo: true);
        } else {
          _fetchSantri(uid, withTarikSaldo: false);
        }
      } else if (key.isNotEmpty) {
        cardInput.value += key;
      }
    }
    return KeyEventResult.handled;
  }

  /// Dialog utama → handle cekSaldo & tarikTunai
  void dialogCek() {
    santri.value = null; // reset dulu

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Focus(
          focusNode: focusNode,
          onKeyEvent: onKeyEvent,
          child: Obx(() {
            final data = santri.value;

            // kalau kartu ketemu + mode tarik-tunai → auto redirect
            if (data != null && currentMode.value == 'Tarik-tunai') {
              Future.delayed(const Duration(seconds: 2), () {
                if (Get.isDialogOpen == true) {
                  Get.back();
                  Get.toNamed(
                    Routes.NOMINAL,
                    arguments: {
                      "santriId": data.id,
                      "santriName": data.name,
                      "type": TransaksiType.tarikTunai,
                    },
                  );
                }
              });
            }

            return Container(
              constraints: BoxConstraints(
                minHeight: 150,
                maxWidth: Get.width * 0.6,
                maxHeight: 250,
              ),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1D2938),
                borderRadius: BorderRadius.circular(16),
                image:
                    data != null && currentMode.value == 'cekSaldo'
                        ? DecorationImage(
                          image: AssetImage("assets/icons/card.png"),
                          fit: BoxFit.fill,
                        )
                        : null,
              ),

              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (data == null) ...[
                          Image.asset("assets/icons/tapKartu.png", width: 60),
                          const SizedBox(height: 16),
                          const Text(
                            "Silahkan Tap kartu anda...",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ] else if (currentMode.value == 'cekSaldo') ...[
                          Text(
                            "Saldo ${data.name} tersisa:",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            formatRupiah(data.saldo),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else if (currentMode.value == 'Tarik-tunai') ...[
                          Image.asset(
                            "assets/icons/kartucek.png",
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Kartu ditemukan",
                            style: TextStyle(fontSize: 16, color: Colors.white),
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
                      onTap: () => Get.back(),
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
      barrierDismissible: false,
    ).then((_) => Get.until((route) => !Get.isDialogOpen!));

    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  /// Dipanggil tombol "Tarik Tunai"
  void openTarikTunai() {
    currentMode.value = 'Tarik-tunai';
    dialogCek();
  }

  /// Dipanggil tombol "Cek Saldo"
  void cekSaldo() {
    currentMode.value = 'cekSaldo';
    dialogCek();
  }

  Future fechtTotalTransaksiHariIni() async {
    try {
      final urlRiwayatTransaksi = Uri.parse("$baseUrl/history");
      final response = await http.get(urlRiwayatTransaksi);

      if (response.statusCode == 200) {
        final data = historyFromJson(response.body);
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final transaksiHariIni =
            data.historyDetail.where((transaksi) {
              final tglTransaksi = DateFormat(
                'yyyy-MM-dd',
              ).format(transaksi.createdAt.toLocal());
              return tglTransaksi == today &&
                  (transaksi.status == 'Lunas' || transaksi.status == 'Hutang');
            }).toList();

        totalTransaksiHariIni.value = transaksiHariIni.fold(0, (sum, t) {
          final totalItem = t.dataitems.fold(
            0,
            (s, item) => s + (item.quantity ?? 0),
          );
          final pajak = totalItem * 500;
          return sum + (t.totalAmount ?? 0) + pajak;
        });

        print('Total transaksi hari ini: ${totalTransaksiHariIni.value}');
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data transaksi',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan koneksi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatRupiah(int amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
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

  Future<void> _fetchSantri(
    String nomorKartu, {
    bool withTarikSaldo = false,
  }) async {
    final url = Uri.parse(
      "$baseUrl/kartu",
    ).replace(queryParameters: {'noKartu': nomorKartu});

    if (isScanning.value) return;

    try {
      isScanning.value = true;
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          final kartuData = Data.fromJson(data);

          santri.value = kartuData.santri;
          _updateSantriData(kartuData.santri);
        } else {
          Get.snackbar('Info', 'Kartu tidak ditemukan');
        }
      } else {
        Get.snackbar('Error', 'Gagal mengambil data.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan koneksi');
    } finally {
      isScanning.value = false;
    }
  }

  void _updateSantriData(Santri santriData) {
    santriName.value = santriData.name ?? "N/A";
    santriKelas.value = santriData.kelas ?? "N/A";
    santriSaldo.value = santriData.saldo ?? 0;
    santriHutang.value = santriData.hutang ?? 0;
  }
}