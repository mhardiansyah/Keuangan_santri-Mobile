import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/history_detail_transaksi.dart';

import 'package:sakusantri/app/core/models/santri_model.dart';

class DetailRiwayatTransaksiController extends GetxController {
  //TODO: Implement DetailRiwayatTransaksiController

  var url = dotenv.env['base_url'];
  var isLoading = false.obs;
  var historydetail = Rxn<DataHistory>(); 
  var santriId = 0;
  final box = Get.arguments;

  @override
  void onInit() {
    santriId = Get.arguments as int;
    super.onInit();
    fetchHistoryBySantriId();
  }

  void fetchHistoryBySantriId() async {
    try {
      isLoading.value = true;
      final res = await http.get(Uri.parse("$url/history/$santriId"));
      if (res.statusCode == 200) {
        final data = historyResponseFromJson(res.body);
        print('data: $data');
        historydetail.value = data.data;
        print('RAW JSON: ${res.body}');
        print('Parsed Nama Santri: ${historydetail.value?.santri.name}');
        print('Parsed Total Amount: ${historydetail.value?.totalAmount}');
      } else {
        Get.snackbar("Error", "Gagal fetch detail history");
      }
    } catch (e) {
      print("Error fetch detail: $e");
    } finally {
      isLoading.value = false;
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

  // void increment() => count.value++;
}
