import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewPasswordController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 10),

                // Logo
                Center(
                  child: Image.asset("assets/icons/mysakudark.png", height: 60),
                ),
                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Masukan Password baru",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),

                // Password Baru
                const Text(
                  "Password Baru",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return Column(
                    children: [
                      TextField(
                        obscureText: true,
                        onChanged: (val) => controller.password.value = val,
                        decoration: InputDecoration(
                          hintText: "Buat Password baru anda",
                          errorText:
                              controller.passwordError.value.isEmpty
                                  ? null
                                  : controller.passwordError.value,
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // Konfirmasi Password
                      const Text(
                        "Konfirm Password",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        obscureText: true,
                        onChanged:
                            (val) => controller.confirmPassword.value = val,
                        decoration: InputDecoration(
                          hintText: "Masukan Password baru anda",
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorText:
                              controller.newPasswordError.value.isEmpty
                                  ? null
                                  : controller.newPasswordError.value,
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                }),

                // Submit Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : controller.resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C3FE4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          controller.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "kirim",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Link ke login
                Center(
                  child: GestureDetector(
                    onTap: () => Get.offAllNamed('/login'),
                    child: const Text.rich(
                      TextSpan(
                        text: "Sudah punya akun? silahkan ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: Color(0xFF4C3FE4),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
}
