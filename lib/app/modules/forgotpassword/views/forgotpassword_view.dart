import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import '../controllers/forgotpassword_controller.dart';

class ForgotpasswordView extends GetView<ForgotpasswordController> {
  const ForgotpasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button di pojok kiri atas
            Padding(
              padding: EdgeInsets.only(top: 8, left: 8),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
                tooltip: 'Back',
              ),
            ),
            // Form di tengah
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40), // Jarak dari atas agar tidak ketabrak tombol back
                      // Logo
                      Image.asset(
                        'assets/icons/logomysaku.png',
                        height: 60,
                      ),
                      SizedBox(height: 32),

                      // Title
                      Text(
                        'Forgot Password',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),

                      // Subtitle
                      Text(
                        "Selamat datang di MySaku",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 32),

                      // Email Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Email Field
                      Obx(() => TextField(
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
                          )),
                      SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.submitEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2ECC71),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Kirim",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Login Link
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.LOGIN),
                        child: RichText(
                          text: TextSpan(
                            text: "Klik disini untuk ",
                            style: TextStyle(color: Colors.grey[600]),
                            children: [
                              TextSpan(
                                text: "LOGIN",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
