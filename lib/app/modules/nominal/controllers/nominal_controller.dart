import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NominalController extends GetxController {
  var selectedNominal = 0.obs;
  final quickAmounts = [20000, 50000, 70000, 100000, 300000, 500000];
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Sinkronisasi input text dengan pilihan nominal
    ever(selectedNominal, (val) {
      final formatted = selectedNominal.value == 0
          ? ''
          : currencyFormatter.format(selectedNominal.value);

      if (textController.text != formatted) {
        textController.text = formatted;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      }
    });
  }

  void pilihNominal(int amount) {
    selectedNominal.value = amount;
  }

  void updateNominalFromText(String value) {
    String numeric = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeric.isNotEmpty) {
      selectedNominal.value = int.parse(numeric);
    } else {
      selectedNominal.value = 0;
    }
  }
}
