import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    RxString logined = "".obs;

    

    Future.delayed(const Duration(seconds: 2), () {
      final token = box.read('access_token');
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(Routes.MAIN_NAVIGATION);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Logo di tengah
          Center(
            child: Image.asset(
              'assets/icons/mysakudark.png',
              width: 320,
              height: 320,
            ),
          ),

          // Teks di bawah
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Dibuat oleh Siswa SMK MQ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
