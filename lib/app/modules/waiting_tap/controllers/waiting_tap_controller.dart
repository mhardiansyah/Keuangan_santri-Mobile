import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class WaitingTapController extends GetxController {
  //TODO: Implement WaitingTapController

  final count = 0.obs;
  var cardInput = ''.obs;
  var cardUID = ''.obs;
  var santri = Rxn<Santri>();
  var url = dotenv.env['base_url'];

  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
      print('focus node jalan di waiting tap: $focusNode');
    });
  }

  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      print(
        ">>> Key pressed: ${event.logicalKey.keyLabel} | debugName: ${event.logicalKey.debugName}",
      );

      if (key == 'Enter') {
        final uid = cardInput.value.trim();
        cardUID.value = uid;
        cardInput.value = '';
        getSantriByUID(uid);
      } else {
        cardInput.value += key;
      }
    }
  }

  void getSantriByUID(String nomor_kartu) async {
    print(">>> getSantriByUID kepanggil dengan noKartu: $nomor_kartu");
    print(">>> URL dipanggil: $url/kartu?noKartu=$nomor_kartu");
    Uri urlWaiting = Uri.parse(
      "$url/kartu",
    ).replace(queryParameters: {'noKartu': nomor_kartu});

    try {
      final response = await http.get(
        urlWaiting,
        headers: {"Content-Type": "application/json"},
      );
      print(">>> status code: ${response.statusCode}");
      print(">>> body: ${response.body}");
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(">>> jsonResponse: $jsonResponse");

        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          final kartu = Data.fromJson(data);
          santri.value = kartu.santri;
          // addCartItems(kartu.santri.id);


          if (kartu.santri != null) {
            Get.toNamed(
              Routes.PAYMENT,
              arguments: {
                'id': kartu.santri.id,
                'nama': kartu.santri.name,
                'passcode': kartu.passcode,
                'kelas': kartu.santri.kelas,
                'saldo': kartu.santri.saldo,
                'hutang': kartu.santri.hutang,
                'kartu_id': kartu.id,
              },
            );
            return;
          }
          Get.snackbar('Info', 'kartu  tidak ditemukan');
        } else {
          Get.snackbar('Error', 'Gagal mengambil data.');
        }
      }
    } catch (e) {
      print('Error fungsi getSantribyUID: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}