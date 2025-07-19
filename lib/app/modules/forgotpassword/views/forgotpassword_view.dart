import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/forgotpassword_controller.dart';

class ForgotpasswordView extends GetView<ForgotpasswordController> {
  const ForgotpasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ForgotpasswordView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ForgotpasswordView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
