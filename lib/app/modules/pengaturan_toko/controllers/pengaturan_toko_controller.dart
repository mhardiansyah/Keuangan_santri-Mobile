import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/core/models/items_model.dart';
import 'package:sakusantri/app/core/models/kategori_model.dart';

class PengaturanTokoController extends GetxController {
  var searchKeyword = ''.obs;
  var url = dotenv.env['base_url'];
  var itemsList = <Items>[].obs;
  var allItems = <Items>[];
  var selectedImage = Rx<File?>(null);
  var existingImageUrl = ''.obs;
  var kategoriList = <Kategori>[].obs;
  var kategoriId = RxnInt();

  var nama = ''.obs;
  var harga = ''.obs;
  var stok = ''.obs;
  var barcode = ''.obs;

  var restockInput = ''.obs;
  var jumlahPerBatch = ''.obs;
  var jumlahDus = ''.obs;
  var dusTersisa = ''.obs;
  var manualStock = ''.obs;
  var tambahDus = ''.obs;

  var editingProduct = Rx<Items?>(null);
  var isLoading = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchKategori();
    fetchProduct();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      existingImageUrl.value = '';
    }
  }

  Future<void> fetchProduct() async {
    try {
      isLoading.value = true;
      var urlItems = Uri.parse("${url}/items");
      final response = await http.get(urlItems);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(response.body);
        final List<dynamic> data = jsonresponse['data'];
        allItems = data.map((item) => Items.fromJson(item)).toList();
        filterProducts();
      } else {
        Get.snackbar('Error', 'Gagal ambil data produk');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed fetch: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void filterProducts() {
    final keyword = searchKeyword.value.toLowerCase();
    itemsList.assignAll(
      allItems.where((item) => item.nama.toLowerCase().contains(keyword)),
    );
  }

  void openAddDialog() {
    nama.value = "";
    harga.value = "";
    stok.value = "";
    barcode.value = "";
    restockInput.value = "";
    jumlahPerBatch.value = "";
    jumlahDus.value = "";
    manualStock.value = "";
    tambahDus.value = "";
    editingProduct.value = null;
    dusTersisa.value = "";
    kategoriId.value = null;
    selectedImage.value = null;
    existingImageUrl.value = '';
    Get.dialog(_buildDialog("Tambah Produk"));
  }

  void openEditDialog(Items product) async {
    if (kategoriList.isEmpty) {
      await fetchKategori();
    }

    nama.value = product.nama;
    harga.value = product.harga.toString();
    stok.value = product.jumlah.toString();
    barcode.value = product.barcode.toString();
    restockInput.value = "";
    editingProduct.value = product;

    kategoriId.value = product.kategoriId;
    print("Kategori ID: ${kategoriId.value}");

    selectedImage.value = null;
    existingImageUrl.value = product.gambar ?? '';
    jumlahPerBatch.value = "";
    jumlahDus.value = "";
    tambahDus.value = "";
    manualStock.value = "";

    Get.dialog(_buildDialog("Edit Produk"));
  }

  Widget _buildDialog(String title) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFF1E293B),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  "Nama Barang",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildTextField("Nama barang", nama),
                const SizedBox(height: 16),

                const Text(
                  "Harga Barang",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                _buildPriceField(harga),
                const SizedBox(height: 16),
                const Text(
                  "Kategori Produk",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value:
                            kategoriList.any((k) => k.id == kategoriId.value)
                                ? kategoriId.value
                                : null,
                        dropdownColor: const Color(0xFF1E293B),
                        iconEnabledColor: Colors.white70,
                        items:
                            kategoriList.map((kategori) {
                              return DropdownMenuItem<int>(
                                value: kategori.id,
                                child: Text(
                                  kategori.nama,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                        hint: const Text(
                          "Pilih Kategori",
                          style: TextStyle(color: Colors.white54),
                        ),
                        onChanged: (val) {
                          kategoriId.value = val;
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
                _buildRestockField(),
                const SizedBox(height: 16),

                const Text(
                  "Upload Foto Produk",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "Upload png/jpg",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.upload, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Obx(() {
                  if (selectedImage.value != null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        selectedImage.value!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (existingImageUrl.value.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        existingImageUrl.value,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: isLoading.value ? null : saveProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4634CC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 14,
                        ),
                      ),
                      child:
                          isLoading.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                "Simpan",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    RxString obs, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Obx(
      () => TextField(
        onChanged: (val) => obs.value = val,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint),
        style: const TextStyle(color: Colors.white),
        controller: TextEditingController(text: obs.value)
          ..selection = TextSelection.collapsed(offset: obs.value.length),
      ),
    );
  }

  Widget _buildRestockField() {
    return Obx(() {
      // kalau lagi edit produk
      if (editingProduct.value != null) {
        final currentStock = editingProduct.value?.jumlah ?? 0;
        final restockPerBatch = int.tryParse(jumlahPerBatch.value) ?? editingProduct.value?.jumlahRestock ?? 1;
        final dusToAdd = int.tryParse(jumlahDus.value) ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Restock Produk",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),

            const Text(
              "Jumlah dus (berapa dus yang akan ditambahkan)",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            _buildTextField("Misal: 2", jumlahDus, keyboardType: TextInputType.number),
            const SizedBox(height: 12),

            const Text(
              "Isi per dus (jumlah item per dus)",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            _buildTextField("Isi per dus", jumlahPerBatch, keyboardType: TextInputType.number),
            const SizedBox(height: 12),

            // show current total stock before manual edit
            Row(
              children: [
                const Text(
                  "Stok saat ini: ",
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  "$currentStock",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Atau ubah stok manual",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            _buildTextField("Stok manual (misal: 24)", manualStock, keyboardType: TextInputType.number),
            const SizedBox(height: 12),

            Text(
              "Stok baru (preview): ${manualStock.value.isNotEmpty ? (int.tryParse(manualStock.value) ?? currentStock) : (dusToAdd > 0 && restockPerBatch > 0 ? (currentStock + (dusToAdd * restockPerBatch)) : currentStock)}",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ],
        );
      } else {
        // kalau lagi tambah produk
        // Create product: allow user to either enter a manual stock value
        // or specify `isi per dus` and `jumlah dus` — if both provided,
        // total stock = isi_per_dus * jumlah_dus. Show preview so it's clear.
        final isiCreate = int.tryParse(jumlahPerBatch.value) ?? 0;
        final dusCreate = int.tryParse(jumlahDus.value) ?? 0;
        final manualCreate = int.tryParse(stok.value) ?? 0;
        final previewCreate = (dusCreate > 0 && isiCreate > 0) ? dusCreate * isiCreate : manualCreate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Stok Awal Produk",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildTextField("Isi manual (contoh: 24)", stok, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            const Text(
              "Atau: masukkan jumlah per dus dan jumlah dus",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              "Isi per dus (jumlah item per dus)",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            _buildTextField("Misal: 12", jumlahPerBatch, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            const Text(
              "Jumlah dus",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            _buildTextField("Misal: 5", jumlahDus, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            Text(
              "Preview stok yang akan disimpan: $previewCreate ${dusCreate > 0 && isiCreate > 0 ? '(menggunakan dus × isi per dus)' : '(menggunakan isi manual)'}",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ],
        );
      }
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildPriceField(RxString obs) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Obx(() {
      TextEditingController controller = TextEditingController(
        text:
            obs.value.isEmpty
                ? ''
                : formatter.format(
                  int.tryParse(obs.value.replaceAll(RegExp(r'[^0-9]'), '')) ??
                      0,
                ),
      );
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );

      return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (val) {
          final numeric = val.replaceAll(RegExp(r'[^0-9]'), '');
          obs.value = numeric;
        },
        decoration: _inputDecoration("Rp 0"),
        style: const TextStyle(color: Colors.white),
      );
    });
  }

  Future<void> saveProduct() async {
    final name = nama.value.trim();
    final price = harga.value.trim();
    final brcode = barcode.value.trim();
    // use jumlahDus as the number of dus to add when restocking
    final restockBatch = int.tryParse(jumlahDus.value) ?? 0;

    if (name.isEmpty || price.isEmpty) {
      Get.snackbar('Error', 'Nama & Harga tidak boleh kosong');
      return;
    }

    try {
      isLoading.value = true;

      final uri = editingProduct.value == null
          ? Uri.parse("${url}/items/create")
          : Uri.parse("${url}/items/update/${editingProduct.value!.id}");

      // CREATE flow
      if (editingProduct.value == null) {
        bool dusJumlahPositive(int isi, int dus) => isi > 0 && dus > 0;

        int computeInitialStock() {
          final isiPerDus = int.tryParse(jumlahPerBatch.value) ?? 0;
          final jumlahDusVal = int.tryParse(jumlahDus.value) ?? 0;
          final manualStok = int.tryParse(stok.value) ?? 0;
          if (dusJumlahPositive(isiPerDus, jumlahDusVal)) {
            return isiPerDus * jumlahDusVal;
          }
          return manualStok;
        }

        final jumlahToCreate = computeInitialStock();

        final request = http.MultipartRequest('POST', uri);
        request.fields['nama'] = name;
        request.fields['harga'] = price;
        request.fields['jumlah'] = jumlahToCreate.toString();
        request.fields['barcode'] = brcode;
        request.fields['kategoriId'] = kategoriId.value?.toString() ?? '';
        request.fields['jumlahRestock'] = jumlahPerBatch.value.isEmpty ? '1' : jumlahPerBatch.value;

        if (selectedImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath('gambar', selectedImage.value!.path),
          );
        }

        final response = await request.send();
        final resBody = await response.stream.bytesToString();

        if (response.statusCode == 200 || response.statusCode == 201) {
          fetchProduct();
          Get.back();
          Get.snackbar(
            'Sukses',
            'Produk berhasil ditambahkan (stok awal: $jumlahToCreate)',
            backgroundColor: Colors.green,
          );
        } else {
          Get.snackbar('Error', 'Gagal simpan produk: $resBody', backgroundColor: Colors.red, colorText: Colors.white);
          print('Gagal simpan produk: $resBody');
        }

      // EDIT flow
      } else {
        final currentStock = editingProduct.value?.jumlah ?? 0;
        final restockPerBatch = int.tryParse(jumlahPerBatch.value) ?? editingProduct.value?.jumlahRestock ?? 1;

        int computeFinalStock() {
          if (manualStock.value.isNotEmpty) {
            return int.tryParse(manualStock.value) ?? currentStock;
          }
          if (tambahDus.value.isNotEmpty) {
            final dusToAdd = int.tryParse(tambahDus.value) ?? 0;
            return currentStock + (dusToAdd * restockPerBatch);
          }
          // default: use restock input (batches * isi per batch)
          final batch = restockBatch;
          return currentStock + (batch * restockPerBatch);
        }

        final finalStock = computeFinalStock();

        final body = jsonEncode({
          'nama': name,
          'harga': price,
          'jumlah': finalStock,
          'barcode': brcode,
          'kategoriId': kategoriId.value,
          'jumlahRestock': restockPerBatch,
        });

        final response = await http.put(uri, headers: {'Content-Type': 'application/json'}, body: body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (restockBatch > 0 && restockPerBatch > 0) {
            saveRestockHistory(editingProduct.value!.id, restockPerBatch * restockBatch);
          }
          fetchProduct();
          Get.back();
          Get.snackbar('Sukses', 'Produk berhasil disimpan! Stok sekarang: $finalStock', backgroundColor: Colors.green);
        } else {
          Get.snackbar('Error', 'Gagal update produk: ${response.body}', backgroundColor: Colors.red, colorText: Colors.white);
          print('Gagal update produk: ${response.body}');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Request gagal: $e', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void saveRestockHistory(int productId, int jumlah) {
    final now = DateTime.now();
    final data = {"jumlah": jumlah, "timestamp": now.toIso8601String()};
    box.write('restock_$productId', data);
  }

  Map<String, dynamic>? getRestockHistory(int productId) {
    final data = box.read('restock_$productId');
    if (data == null) return null;

    final time = DateTime.tryParse(data['timestamp'] ?? '');
    if (time == null) return null;

    if (DateTime.now().difference(time).inHours >= 24) {
      box.remove('restock_$productId');
      return null;
    }
    return data;
  }

  Future<void> fetchKategori() async {
    try {
      var res = await http.get(Uri.parse("${url}/kategori"));
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonresponse = json.decode(res.body);
        final List data = jsonresponse['data'];
        print('result: $data');
        kategoriList.assignAll(data.map((e) => Kategori.fromJson(e)).toList());
      } else {
        Get.snackbar("Error", "Gagal ambil data kategori");
      }
    } catch (e) {
      Get.snackbar("Error", "Fetch kategori gagal: $e");
    }
  }
  Future<void> tambahStok(Items product) async {
  try {
    final newStock = product.jumlah + 1;

    final uri = Uri.parse("${url}/items/update/${product.id}");
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": product.nama,
        "harga": product.harga,
        "jumlah": newStock,
        "barcode": product.barcode,
        "kategoriId": product.kategoriId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      product.jumlah = newStock; // update lokal
      itemsList.refresh(); // refresh UI
      Get.snackbar("Berhasil", "Stok ${product.nama} ditambah 1",
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Error", "Gagal update stok", backgroundColor: Colors.red);
    }
  } catch (e) {
    Get.snackbar("Error", "Gagal menambah stok: $e", backgroundColor: Colors.red);
  }
}

}
