import 'package:bcrypt/bcrypt.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakusantri/app/core/types/transaksi_type.dart';
import 'package:sakusantri/app/routes/app_pages.dart';

class EnterPasscodeController extends GetxController {
  var pin = ''.obs;

  //data arguments
  var santriId = 0.obs;
  var name = ''.obs;
  var passcode = ''.obs;
  var kelas = ''.obs;
  var saldo = 0.obs;
  var hutang = 0.obs;
  var methodpayment = ''.obs;

  // data dari getorage
  var totalHargaPokok = 0.obs;
  var pajak = 0.obs;
  var totalPembayaran = 0.obs;
  final box = GetStorage();

  void onInit() {
    final arguments = Get.arguments;
    if (arguments != null) {
      santriId.value = arguments['id'] ?? 0;
      name.value = arguments['santriName'] ?? '';
      passcode.value = arguments['passcode'] ?? '';
      kelas.value = arguments['kelas'] ?? '';
      saldo.value = arguments['saldo'] ?? 0;
      hutang.value = arguments['hutang'] ?? 0;
      methodpayment.value = arguments['method'] ?? '';
    }
    totalPembayaran.value = box.read('totalPembayaran') ?? 0;
    super.onInit();
  }

  @override
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

      print("passcode dari db: $passcode");

      final isvalid = BCrypt.checkpw(pin.value, passcode.value);
      print("hasil dari compare: $isvalid");

      if (isvalid) {
        Get.snackbar("Success", "PIN benar");
        Get.toNamed(
          Routes.NOTIF_PEMBAYARAN,
          arguments: {
            'method': methodpayment.value,
            'total': totalPembayaran.value,
            'santriName': name.value,
            'passcode': passcode.value,
            'santriId': santriId.value,
            'type': TransaksiType.pembayaran,
          },
        );
      } else {
        Get.snackbar("Error", "PIN salah");
      }
    }
  }
}
