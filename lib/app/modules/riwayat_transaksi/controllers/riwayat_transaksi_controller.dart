// ignore_for_file: unnecessary_cast
import 'package:get/get.dart';

class RiwayatTransaksiController extends GetxController {
  var selectedKelas = 'ALL'.obs;
  var searchQuery = ''.obs;

  var transaksiHariIni = <Map<String, dynamic>>[].obs;
  var transaksiKemaren = <Map<String, dynamic>>[].obs;

  var filteredHariIni = <Map<String, dynamic>>[].obs;
  var filteredKemaren = <Map<String, dynamic>>[].obs;

  /// Dummy data transaksi per kelas
  final Map<String, Map<String, List<Map<String, dynamic>>>> _dummyData = {
    'XII': {
      'hariIni': [
        {
          'nama': 'Muhammad Dafleng',
          'kelas': 'XII',
          'status': 'Lunas',
          'nominal': '20.000',
          'tanggal': '2025-08-21',
          'image': 'assets/images/user1.png',
        },
        {
          'nama': 'Aditiya Rahsya',
          'kelas': 'XII',
          'status': 'Lunas',
          'nominal': '15.000',
          'tanggal': '2025-08-21',
          'image': 'assets/images/user1.png',
        },
      ],
      'kemaren': [
        {
          'nama': 'Muhammad Dafleng',
          'kelas': 'XII',
          'status': 'Hutang',
          'nominal': '20.000',
          'tanggal': '2025-08-20',
          'image': 'assets/images/user2.png',
        },
        {
          'nama': 'Aditiya Rahsya',
          'kelas': 'XII',
          'status': 'Lunas',
          'nominal': '15.000',
          'tanggal': '2025-08-20',
          'image': 'assets/images/user1.png',
        },
      ],
    },
    'XI': {
      'hariIni': [
        {
          'nama': 'Budi Santoso',
          'kelas': 'XI',
          'status': 'Lunas',
          'nominal': '10.000',
          'tanggal': '2025-08-21',
          'image': 'assets/images/user1.png',
        },
      ],
      'kemaren': [
        {
          'nama': 'Andi Pratama',
          'kelas': 'XI',
          'status': 'Hutang',
          'nominal': '5.000',
          'tanggal': '2025-08-20',
          'image': 'assets/images/user2.png',
        },
      ],
    },
    'X': {
      'hariIni': [
        {
          'nama': 'Siti Aminah',
          'kelas': 'X',
          'status': 'Lunas',
          'nominal': '12.000',
          'tanggal': '2025-08-21',
          'image': 'assets/images/user1.png',
        },
      ],
      'kemaren': [
        {
          'nama': 'Joko Widodo',
          'kelas': 'X',
          'status': 'Hutang',
          'nominal': '8.000',
          'tanggal': '2025-08-20',
          'image': 'assets/images/user2.png',
        },
      ],
    },
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
    if (selectedKelas.value == 'ALL') {
      transaksiHariIni.value = _dummyData.values
          .expand((kelasData) => kelasData['hariIni']!)
          .toList();

      transaksiKemaren.value = _dummyData.values
          .expand((kelasData) => kelasData['kemaren']!)
          .toList();
    } else {
      final data = _dummyData[selectedKelas.value] ?? {
        'hariIni': [],
        'kemaren': [],
      };

      transaksiHariIni.value =
          (data['hariIni'] as List?)?.cast<Map<String, dynamic>>() ?? [];

      transaksiKemaren.value =
          (data['kemaren'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    }

    filterTransaksiBySearch();
  }

  void filterTransaksiBySearch() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredHariIni.value = transaksiHariIni;
      filteredKemaren.value = transaksiKemaren;
    } else {
      filteredHariIni.value = transaksiHariIni
          .where(
              (item) => item['nama'].toString().toLowerCase().contains(query))
          .toList();

      filteredKemaren.value = transaksiKemaren
          .where(
              (item) => item['nama'].toString().toLowerCase().contains(query))
          .toList();
    }
  }
}
