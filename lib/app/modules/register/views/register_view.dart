// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset('assets/icons/logomysaku.png', height: 72),
                  SizedBox(height: 32),

                  // Title
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),

                  // Subtitle
                  Text(
                    'Welcome Back to MySaku!',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  SizedBox(height: 32),

                  // Name Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Name Field
                  Obx(
                    () => TextField(
                      onChanged: (value) => controller.name.value = value,
                      decoration: InputDecoration(
                        hintText: "Masukan Nama Anda",
                        errorText: controller.nameError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Email Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Email Field
                  Obx(
                    () => TextField(
                      onChanged: (value) => controller.email.value = value,
                      decoration: InputDecoration(
                        hintText: "Masukan Email Anda",
                        errorText: controller.emailError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Password Field
                  Obx(
                    () => TextField(
                      onChanged: (value) => controller.password.value = value,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: "Masukan Password Anda",
                        errorText: controller.passwordError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Confirm Password Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Confirm Password Field
                  Obx(
                    () => TextField(
                      onChanged:
                          (value) => controller.confirmPassword.value = value,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: InputDecoration(
                        hintText: "Masukan Konfirmasi Password",
                        errorText: controller.confirmPasswordError.value,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2ECC71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (controller.validateForm()) {
                          controller.register();
                        }
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account? "),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/login');
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Color(0xFF2ECC71),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
