// ignore_for_file: unnecessary_cast

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/history_transaksi_model.dart';

class RiwayatTransaksiController extends GetxController {
  var selectedKelas = 'Semua'.obs;
  var searchQuery = ''.obs;
  var url = dotenv.env['base_url'];
  var allHistoryList = <HistoryDetail>[].obs;
  var allHistoryFiltered = <HistoryDetail>[].obs;

  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchRiwayatTransaksi();
  }

  String convertKelas(String kelas) {
    switch (kelas) {
      case "12":
        return "XII";
      case "11":
        return "XI";
      case "10":
        return "X";
      default:
        return kelas;
    }
  }

  void setKelas(String kelas) {
    selectedKelas.value = kelas;
    applyFilter();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilter();
  }

  void applyFilter() {
    final kelas = selectedKelas.value;
    final query = searchQuery.value.toLowerCase();

    allHistoryFiltered.assignAll(
      allHistoryList.where((item) {
        final matchKelas =
            (kelas == 'Semua') ? true : convertKelas(item.santri.kelas) == kelas;

        final matchQuery = item.santri.name.toLowerCase().contains(query);

        return matchKelas && matchQuery;
      }),
    );
  }

  void fetchRiwayatTransaksi() async {
    try {
      isLoading.value = true;
      var urlRiwayatTransaksi = Uri.parse("$url/history");
      final response = await http.get(urlRiwayatTransaksi);
      if (response.statusCode == 200) {
        final data = historyFromJson(response.body);

        allHistoryList.value = data.historyDetail;
        applyFilter();
      } else {
        Get.snackbar('Error', 'Failed to fetch transaction history');
        print("Failed with status code: ${response.statusCode}");
        print('isi gagal: ${response.body}');
      }
    } catch (e) {
      print("Error fetching transaction history: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
