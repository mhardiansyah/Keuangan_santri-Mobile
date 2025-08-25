import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/enter_passcode_controller.dart';

class EnterPasscodeView extends GetView<EnterPasscodeController> {
  const EnterPasscodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnterPasscodeController());

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Masukan PIN kartu",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 40),

                  // PIN Indicator
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          bool filled = index < controller.pin.value.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: filled
                                  ? const Icon(Icons.circle,
                                      size: 14, color: Colors.white)
                                  : null,
                            ),
                          );
                        }),
                      )),
                  const SizedBox(height: 50),

                  // Keypad
                  _buildKeypad(controller),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: GestureDetector(
                  onTap: controller.submit,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(EnterPasscodeController controller) {
    final keys = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"],
      [".", "0", "del"],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            return GestureDetector(
              onTap: () {
                if (key == "del") {
                  controller.deleteDigit();
                } else if (key != ".") {
                  controller.addDigit(key);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(14),
                width: 80,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: key == "del"
                      ? const Icon(Icons.backspace, color: Colors.white)
                      : Text(
                          key,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
