import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Penting: gunakan KeyEvent dari sini
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sakusantri/app/core/models/login_model.dart';
import 'package:sakusantri/app/core/models/santri_model.dart';
import 'package:sakusantri/app/core/models/items_model.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var itemsList = <Items>[].obs;
  var cardInput = ''.obs;
  var cardUID = ''.obs;
  var dataLogin = Rxn<Login>();
  var santri = Rxn<Santri>();

  FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    getData();
    Future.delayed(Duration.zero, () {
      focusNode.requestFocus();
    });
  }

  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('login');
    if (jsonString != null) {
      dataLogin.value = Login.fromJson(json.decode(jsonString));
    }
  }

  /// ✅ Gantikan RawKeyEvent dengan KeyEvent (non-deprecated)
  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey.keyLabel;

      if (key == 'Enter') {
        final uid = cardInput.value.trim();
        cardUID.value = uid;
        getSantriByUID(uid);
        cardInput.value = '';

        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back(); // tutup dialog jika terbuka
          dialogCek(); // munculkan ulang
        });
      } else {
        cardInput.value += key;
      }
    }
    return KeyEventResult.handled;
  }

  void dialogCek() {
    final controller = Get.find<HomeController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 150),
          child: Obx(() {
            final data = controller.santri.value;

            if (data == null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Tempelkan kartu...", style: TextStyle(fontSize: 16)),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data Santri",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                infoRow("Nama", data.name ?? "N/A"),
                infoRow("Kelas", data.kelas ?? "N/A"),
                infoRow("Saldo", "Rp ${data.saldo}" ?? "N/A"),
                infoRow("Hutang", "Rp ${data.hutang}" ?? "N/A"),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      controller.santri.value = null;
                    },
                    child: const Text("Tutup"),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void getSantriByUID(String uid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('login');

    if (jsonString == null) return;

    final login = Login.fromJson(json.decode(jsonString));
    final token = "Bearer ${login.accessToken}";

    Uri url = Uri.parse("http://10.0.2.2:5000/santri/find-by-uid/$uid");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json", "Authorization": token},
      );

      if (response.statusCode == 200) {
        Santri data = santriFromJson(response.body);
        santri.value = data;
      } else {
        santri.value = null;
      }
    } catch (e) {
      print('Error getSantriByUID: $e');
    }
  }
}
