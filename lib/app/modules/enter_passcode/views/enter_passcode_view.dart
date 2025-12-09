import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/enter_passcode_controller.dart';

class EnterPasscodeView extends GetView<EnterPasscodeController> {
  const EnterPasscodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Column(
            children: [
              const Spacer(),

              // Title
              const Text(
                "Masukan PIN kartu",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 30),

              // PIN Input
              Obx(
                () => AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.opacity.value,
                  child: Pinput(
                    controller: controller.pinController,
                    length: 6,
                    obscureText: true,
                    obscuringWidget: const Icon(
                      Icons.circle,
                      size: 14,
                      color: Colors.white,
                    ),
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: controller.borderColor.value,
                        ),
                      ),
                    ),
                    onChanged: (value) => controller.pin.value = value,
                    onCompleted: (value) {
                      controller.pin.value = value;
                      controller.submit();
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Tombol Bayar (Fixed bottom)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: GestureDetector(
                  onTap: controller.submit,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4634CC),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Bayar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
