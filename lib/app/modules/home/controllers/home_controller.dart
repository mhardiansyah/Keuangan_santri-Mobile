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

  void connectToUsbReader() async {
    print('Mencari perangkat USB...');
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      print('Tidak ada perangkat USB yang terdeteksi');
      return;
    }

    UsbDevice device = devices.first;
    print('Perangkat USB ditemukan: ${device.productName}');

    UsbPort? port = await device.create();
    if (port == null) {
      print('Gagal membuka port USB');
      return;
    }

    bool openResult = await port.open();
    if (!openResult) {
      print('Gagal membuka koneksi ke perangkat USB');
      return;
    }

    await port.setDTR(true);
    await port.setRTS(true);
    await port.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );
    print('Koneksi ke perangkat USB berhasil');

    List<int> command = [0xFF, 0x00, 0x00, 0x00]; // Contoh perintah
    await port.write(Uint8List.fromList(command));

    Stream<Uint8List>? inputStream = port.inputStream;
    if (inputStream != null) {
      inputStream.listen((Uint8List data) {
        print('Respons dari perangkat: $data');
      });
    } else {
      print('Tidak ada data yang diterima dari perangkat');
    }

    // Setelah koneksi USB selesai, langsung scan NFC
    await nfcScan();

    await port.close();
    print('Koneksi ke perangkat USB ditutup');
  }

  Future<void> nfcScan() async {
    print('Memulai proses NFC scan...');

    try {
      // Gunakan nfc_manager untuk memeriksa ketersediaan NFC
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        print('NFC tidak tersedia di perangkat ini');
        cardId.value = 'NFC tidak tersedia';
        return;
      }

      // Logika membaca tag NFC
      NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443, // Contoh protokol NFC yang didukung
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            // Contoh membaca data dari tag
            print('Tag NFC ditemukan: ${tag.data}');
            cardId.value = tag.data.toString();
          } catch (e) {
            print('Gagal membaca tag NFC: $e');
            cardId.value = 'Error membaca tag NFC';
          } finally {
            NfcManager.instance.stopSession();
          }
        },
      );
    } catch (e) {
      print('Terjadi error saat proses NFC: $e');
      cardId.value = 'Error NFC: $e';
    }
  }

  Future<void> nfcScanInternal() async {
    print('Memulai proses NFC scan internal...');

    try {
      // Gunakan nfc_manager untuk memeriksa ketersediaan NFC
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        print('NFC tidak tersedia di perangkat ini');
        cardId.value = 'NFC tidak tersedia';
        return;
      }

      // Logika membaca tag NFC
      NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443, // Contoh protokol NFC yang didukung
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            // Contoh membaca data dari tag
            print('Tag NFC ditemukan: ${tag.data}');
            cardId.value = tag.data.toString();
          } catch (e) {
            print('Gagal membaca tag NFC: $e');
            cardId.value = 'Error membaca tag NFC';
          } finally {
            NfcManager.instance.stopSession();
          }
        },
      );
    } catch (e) {
      print('Terjadi error saat proses NFC: $e');
      cardId.value = 'Error NFC: $e';
    }
  }
}
