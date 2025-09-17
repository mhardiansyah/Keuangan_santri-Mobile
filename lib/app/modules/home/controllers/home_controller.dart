// ignore_for_file: avoid_print

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
    Timer.periodic(Duration(seconds: 1), (timer) {
      updateTime();
    });
    Future.delayed(Duration.zero, () => focusNode.requestFocus());
    print("focus node: $focusNode");
    fechtTotalTransaksiHariIni();

    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   print('timer started');
    //   print('timer: ${timer.tick}');
    //   fechtTotalTransaksiHariIni();
    //   print('total transaksi hari ini: ${totalTransaksiHariIni.value}');
    // });
  }

  void updateTime() {
    final now = DateTime.now();
    currentTime.value = DateFormat('HH:mm:ss').format(now);
    currentDate.value = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now);

    // currentTime.value = formattedTime;
    // currentDate.value = formattedDate;
  }

  /// Handler input kartu via keyboard
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      // ambil karakter asli, bukan keyLabel
      final key = event.logicalKey.keyLabel;
      print("Key pressed: $key");

      if (event.logicalKey == LogicalKeyboardKey.enter) {
        print('input mentah: ${cardInput.value}');
        print('input mentah uid: ${cardUID.value}');

        final uid = cardInput.value.trim();
        if (isScanning.value) {
          print("⏳ Masih scanning, abaikan kartu: $uid");
          cardInput.value = '';
          return KeyEventResult.handled;
        }
        cardUID.value = uid;

        print('Input kartu selesai: $uid');
        cardInput.value = '';
        if (currentMode.value == 'Tarik-tunai') {
          _fetchSantri(uid, withTarikSaldo: true);
        } else {
          _fetchSantri(uid, withTarikSaldo: false);
        }
      } else if (key != null && key.isNotEmpty) {
        cardInput.value += key;
        print("Key pressed: $key (accumulated: ${cardInput.value})");
      }
    }
    return KeyEventResult.handled;
  }

  /// Dialog untuk cek saldo / tarik tunai
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
                            style: TextStyle(
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
                      onTap: Get.back,
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

  Future fechtTotalTransaksiHariIni() async {
    try {
      final urlRiwayatTransaksi = Uri.parse("$baseUrl/history");
      final response = await http.get(urlRiwayatTransaksi);

      if (response.statusCode == 200) {
        final data = historyFromJson(response.body);
        print('data transaksi: ${data.historyDetail}');
        print('jumlah data transaksi: ${data.historyDetail.length}');
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final transaksiHariIni =
            data.historyDetail.where((transaksi) {
              final tglTransaksi = DateFormat(
                'yyyy-MM-dd',
              ).format(transaksi.createdAt.toLocal());

              return tglTransaksi == today &&
                  (transaksi.status == 'Lunas' || transaksi.status == 'Hutang');
            }).toList();

        totalTransaksiHariIni.value = transaksiHariIni.fold(
          0,
          (sum, t) => sum + (t.totalAmount ?? 0),
        );

        print("Total transaksi hari ini: ${totalTransaksiHariIni.value}");
      } else {
        Get.snackbar('Error', 'Gagal mengambil data transaksi');
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Terjadi kesalahan koneksi');
    }
  }

  /// Ganti mode dialog
  void openTarikTunai() {
    currentMode.value = 'Tarik-tunai';
    dialogCek();
  }

  void cekSaldo() {
    currentMode.value = 'cekSaldo';
    dialogCek();
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

  /// Request API untuk ambil santri
  Future<void> _fetchSantri(
    String nomorKartu, {
    bool withTarikSaldo = false,
  }) async {
    print('kartu yang di tap $nomorKartu');

    santri.value = null;
    // santri.refresh();
    if (withTarikSaldo && currentMode.value != 'Tarik-tunai') {
      print("❌ Abaikan fetchSantri karena bukan mode Tarik-tunai");
      return;
    }
    if (!withTarikSaldo && currentMode.value != 'cekSaldo') {
      print("❌ Abaikan fetchSantri karena bukan mode cekSaldo");
      return;
    }

    final url = Uri.parse(
      "$baseUrl/kartu",
    ).replace(queryParameters: {'noKartu': nomorKartu});
    print("👉 Fetch dengan nomorKartu='$nomorKartu'");

    if (isScanning.value) {
      print("❌ Abaikan karena masih proses kartu lain");
      return;
    }

    try {
      isScanning.value = true;
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("Response body: ${response.body}");
        print("Data type: ${jsonResponse['data'].runtimeType}");

        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          final kartuData = Data.fromJson(data);

          santri.value = kartuData.santri;
          _updateSantriData(kartuData.santri);

          if (withTarikSaldo == true && currentMode.value == 'Tarik-tunai') {
            _showTarikTunaiDialog(kartuData);
            return;
          } else if (withTarikSaldo == false &&
              currentMode.value == 'cekSaldo') {
            Get.snackbar(
              'Info',
              'Kartu ditemukan: ${kartuData.santri?.name ?? "-"}',
            );
          } else {
            Get.back();
          }

          return;
        }
        Get.snackbar('Info', 'Kartu tidak ditemukan');
      } else {
        Get.snackbar('Error', 'Gagal mengambil data.');
      }
    } catch (e) {
      print('Error fetchSantri: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan koneksi.',
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    } finally {
      isScanning.value = false;
    }
  }

  void _showTarikTunaiDialog(Data kartu) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              Image.asset("assets/icons/kartucek.png", width: 60),
              const SizedBox(height: 16),
              const Text(
                "Kartu ditemukan",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen == true) {
        Get.until((route) => !Get.isDialogOpen!);
      }

      Get.toNamed(
        Routes.NOMINAL,
        arguments: {
          "santriId": kartu.santri?.id,
          "santriName": kartu.santri?.name,
          "type": TransaksiType.topUp,
        },
      );
    });
  }

  void _updateSantriData(Santri santriData) {
    santriName.value = santriData.name ?? "N/A";
    santriKelas.value = santriData.kelas ?? "N/A";
    santriSaldo.value = santriData.saldo ?? 0;
    santriHutang.value = santriData.hutang ?? 0;
  }
}
