// ignore_for_file: unnecessary_cast

import 'package:get/get.dart';

class RiwayatTransaksiController extends GetxController {
  var selectedKelas = 'XII'.obs;
  var searchQuery = ''.obs;

  var transaksiHariIni = <Map<String, dynamic>>[].obs;
  var transaksiKemaren = <Map<String, dynamic>>[].obs;

  var filteredHariIni = <Map<String, dynamic>>[].obs;
  var filteredKemaren = <Map<String, dynamic>>[].obs;

  final _dummyData = {
    'XII': {
      'hariIni': [
        {
          'nama': 'Muhammad Dafleng',
          'kelas': 'XII',
          'status': 'Lunas',
          'nominal': '20.000',
          'image': 'assets/images/user1.png',
        },
        {
          'nama': 'Aditiya Rahsya',
          'kelas': 'XII',
          'status': 'Lunas',
          'nominal': '15.000',
          'image': 'assets/images/user1.png',
        },
      ],
      'kemaren': [
        {
          'nama': 'Muhammad Dafleng',
          'kelas': 'XII',
          'status': 'Hutang',
          'nominal': '20.000',
          'image': 'assets/images/user2.png',
        },
        {
          'nama': 'Aditiya Rahsya',
          'kelas': 'XII',
          'status': 'Lunas',
          'nominal': '15.000',
          'image': 'assets/images/user1.png',
        },
      ],
    },
    'XI': {'hariIni': [], 'kemaren': []},
    'X': {'hariIni': [], 'kemaren': []},
  };

  @override
  void onInit() {
    super.onInit();
    loadTransaksi();
  }

  void setKelas(String kelas) {
    selectedKelas.value = kelas;
    loadTransaksi();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterTransaksiBySearch();
  }

  void loadTransaksi() {
    final data = _dummyData[selectedKelas.value] ?? {};

    transaksiHariIni.value =
        (data['hariIni'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    transaksiKemaren.value =
        (data['kemaren'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    filterTransaksiBySearch();
  }

  void filterTransaksiBySearch() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredHariIni.value = transaksiHariIni;
      filteredKemaren.value = transaksiKemaren;
    } else {
      filteredHariIni.value = transaksiHariIni
          .where((item) => item['nama'].toString().toLowerCase().contains(query))
          .toList();

      filteredKemaren.value = transaksiKemaren
          .where((item) => item['nama'].toString().toLowerCase().contains(query))
          .toList();
    }
  }
}
