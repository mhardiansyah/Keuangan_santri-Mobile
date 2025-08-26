import 'package:get/get.dart';

class NotifPembayaranController extends GetxController {
  var totalHarga = 0.obs;
  var selectedMethod = ''.obs;
  var santriName = ''.obs;
  var santriId = 0.obs;
  var transaksiType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    print("Arguments diterima: $args");
    if (args != null) {
      totalHarga.value = args['total'] ?? 0;
      selectedMethod.value = args['method'] ?? '-';
      santriName.value = args['santriName'] ?? 'User';
      santriId.value = args['santriId'] ?? 0;
      transaksiType.value = args['type'] ?? '-';
    }
  }


  Future<void> processHistory() async {
    print("Proses pembayaran untuk santriId: ${santriId.value}");

  }
}
