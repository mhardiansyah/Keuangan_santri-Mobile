import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/history_transaksi_model.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';

class RiwayatHutangController extends GetxController {
  var searchQuery = "".obs;
  var selectedKelas = "ALL".obs;
  var isLoading = false.obs;
  var allSantriList = <Santri>[].obs;
  var allSantriFiltered = <Santri>[].obs;
  var url = dotenv.env['base_url'];

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatTransaksi();
  }

  void fetchRiwayatTransaksi() async {
    try {
      isLoading.value = true;
      var urlSantri = Uri.parse('$url/santri');
      final response = await http.get(urlSantri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        allSantriList.value = data.map((e) => Santri.fromJson(e)).toList();
        allSantriList.sort((a, b) => b.hutang.compareTo(a.hutang));
      } else {
        Get.snackbar("Error", "Failed to load santri data");
        print("Failed to load santri data: ${response.statusCode}");
        print('gagal get: ${response.body}');
      }
    } catch (e) {
      print("Error fetching transaction history: $e");
    } finally {
      isLoading.value = false;
    }
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

  List<Santri> get filteredSantri {
    final query = searchQuery.value.toLowerCase();
    final kelasFilter = selectedKelas.value;
    return allSantriList.where((e) {
      final matchesQuery = e.name.toLowerCase().contains(query);
      final kelasSantri = convertKelas(e.kelas);
      final matchesKelas = (kelasFilter == "ALL" || kelasSantri == kelasFilter);
      return matchesQuery && matchesKelas;
    }).toList();
  }

  int getRank(Santri santri) {
    return allSantriList.indexWhere((s) => s.id == santri.id) + 1;
  }

  Future<List<HistoryDetail>> fetchHistoryBySantr(int santriId) async {
    try {
      var urlHistory = Uri.parse("$url/history?santriId=$santriId");
      final response = await http.get(urlHistory);
      if (response.statusCode == 200) {
        final data = historyFromJson(response.body);
        return data.historyDetail;
      } else {
        print("Failed to load history data: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching history data: $e");
      return [];
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setKelas(String kelas) {
    selectedKelas.value = kelas;
  }
}
