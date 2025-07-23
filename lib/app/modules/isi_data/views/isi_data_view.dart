// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/isi_data/controllers/isi_data_controller.dart';

class IsiDataView extends GetView<IsiDataController> {
  IsiDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/logomysaku.png', height: 72),
                  const SizedBox(height: 32),

                  const Text(
                    'Isi Data',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Silahkan isi data perusahaan anda",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),

                  buildLabel("Nama Perusahaan"),
                  Obx(
                    () => TextField(
                      onChanged: (v) => controller.namaPerusahaan.value = v,
                      decoration: InputDecoration(
                        hintText: "Masukan Nama Perusahaan anda",
                        errorText: controller.namaError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  buildLabel("Alamat"),
                  Obx(
                    () => TextField(
                      onChanged: (v) => controller.alamat.value = v,
                      decoration: InputDecoration(
                        hintText: "Masukan Alamat anda",
                        errorText: controller.alamatError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  buildLabel("No Telp"),
                  Obx(
                    () => TextField(
                      onChanged: (v) => controller.noTelp.value = v,
                      decoration: InputDecoration(
                        hintText: "Masukan No Telp Perusahaan",
                        errorText: controller.telpError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(height: 20),

                  buildLabel("Logo Perusahaan"),
                  Obx(
                    () => InkWell(
                      onTap: controller.pickLogo,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.logoFile.value == null
                                  ? 'Upload PNG/JPG'
                                  : 'Logo dipilih',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            const Icon(Icons.upload, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.kirimData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2ECC71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Kirim",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
