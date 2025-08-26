import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
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
    });
  }

  void onKeyEvent(KeyEvent event) {
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
  }

  void getSantriByUID(String nomor_kartu) async {
    Uri urlWaiting = Uri.parse(
      "$url/kartu",
    ).replace(queryParameters: {'noKartu': nomor_kartu});

    try {
      final response = await http.get(
        urlWaiting,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          final kartu = Data.fromJson(data);
          santri.value = kartu.santri;
          if (kartu.santri != null) {
            Get.offAllNamed(
              Routes.PAYMENT,
              arguments: {
                'id': kartu.santri?.id,
                'nama': kartu.santri?.name,
                'kelas': kartu.santri?.kelas,
                'saldo': kartu.santri?.saldo,
                'hutang': kartu.santri?.hutang,
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
    super.onClose();
  }

  void increment() => count.value++;
}
