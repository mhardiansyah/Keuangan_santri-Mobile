import 'package:get/get.dart';

class RiwayatHutangController extends GetxController {
  var searchQuery = "".obs;
  var selectedKelas = "ALL".obs;

  var riwayatHutang = <Map<String, dynamic>>[
    {
      "nama": "Muhammad Dafleng",
      "kelas": "XII",
      "nominal": 20000,
      "image": "assets/images/user1.png",
    },
    {
      "nama": "Andi Pratama",
      "kelas": "XI",
      "nominal": 50000,
      "image": "assets/images/user1.png",
    },
    {
      "nama": "Budi Santoso",
      "kelas": "XI",
      "nominal": 100000,
      "image": "assets/images/user1.png",
    },
    {
      "nama": "Citra Dewi",
      "kelas": "XII",
      "nominal": 75000,
      "image": "assets/images/user1.png",
    },
  ].obs;

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setKelas(String kelas) {
    selectedKelas.value = kelas;
  }

  List<Map<String, dynamic>> get filteredData {
    final query = searchQuery.value.toLowerCase();

    return riwayatHutang.where((e) {
      final matchNama = e['nama'].toString().toLowerCase().contains(query);
      final matchKelas = selectedKelas.value == "ALL" || e['kelas'] == selectedKelas.value;
      return matchNama && matchKelas;
    }).toList();
  }

  List<Map<String, dynamic>> get sortedByHutang {
    final data = [...filteredData];
    data.sort((a, b) => b['nominal'].compareTo(a['nominal']));
    return data;
  }
}
