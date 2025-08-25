import 'package:get/get.dart';

class EnterPasscodeController extends GetxController {
  var pin = ''.obs;

  void addDigit(String digit) {
    if (pin.value.length < 6) {
      pin.value += digit;
    }
  }

  void deleteDigit() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  void submit() {
    if (pin.value.length == 6) {
      // TODO: proses PIN validasi
      print("PIN dimasukkan: ${pin.value}");
    }
  }
}
