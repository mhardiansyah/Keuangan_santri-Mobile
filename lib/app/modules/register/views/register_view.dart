// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/SMK MQ.png', 
                  height: 120,
                ),
              ),
               SizedBox(height: 24),
              Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 4),
              Text(
                'Welcome Back to MySaku!',
                style: TextStyle(color: Colors.grey[600]),
              ),
               SizedBox(height: 32),
              Obx(() => TextField(
                    onChanged: (val) => controller.name.value = val,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Name',
                      labelText: 'Nama',
                      errorText: controller.nameError.value,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )),
               SizedBox(height: 16),
              Obx(() => TextField(
                    onChanged: (val) => controller.email.value = val,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email',
                      labelText: 'Email',
                      errorText: controller.emailError.value,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  )),
               SizedBox(height: 16),
              Obx(() => TextField(
                    onChanged: (val) => controller.password.value = val,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      labelText: 'Password',
                      errorText: controller.passwordError.value,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),
               SizedBox(height: 16),
              Obx(() => TextField(
                    onChanged: (val) =>
                        controller.confirmPassword.value = val,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Password',
                      labelText: 'Confirm Password',
                      errorText: controller.confirmPasswordError.value,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(controller.isConfirmPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  )),
               SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xFF2ECC71), // Hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (controller.validateForm()) {
                      controller.register();
                    }
                  },
                  child:  Text(
                    'register',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Already have account? "),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/login');
                    },
                    child:  Text(
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
    );
  }
}
