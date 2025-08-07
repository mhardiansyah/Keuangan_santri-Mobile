// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:sakusantri/app/core/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:nfc_manager/nfc_manager.dart'; // Ganti library NFC
import 'package:sakusantri/app/core/models/items_model.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var itemsList = <Items>[].obs;
  var cardId = ''.obs;
  var dataLogin = Rxn<Login>();


  void getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('login');
    if (jsonString != null) {
      dataLogin.value = Login.fromJson(json.decode(jsonString));
    }
  }



}
