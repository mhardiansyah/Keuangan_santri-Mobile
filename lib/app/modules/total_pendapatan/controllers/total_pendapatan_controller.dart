import 'package:get/get.dart';

class TotalPendapatanController extends GetxController {
  var selectedFilter = "Harian".obs;

  // Data dummy
  final pendapatan = {
    "Pagi": [
      {"kategori": "Makanan Ringan", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Makanan Basah", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Minuman", "jumlah": 5, "harga": "50.000"},
    ],
    "Siang": [
      {"kategori": "Makanan Ringan", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Makanan Basah", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Minuman", "jumlah": 5, "harga": "50.000"},
    ],
    "Sore": [
      {"kategori": "Makanan Ringan", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Makanan Basah", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Minuman", "jumlah": 5, "harga": "50.000"},
    ],
    "Malam": [
      {"kategori": "Makanan Ringan", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Makanan Basah", "jumlah": 5, "harga": "50.000"},
      {"kategori": "Minuman", "jumlah": 5, "harga": "50.000"},
    ],
  }.obs;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
