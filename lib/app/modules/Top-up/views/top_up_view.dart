import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/top_up_controller.dart';

class TopUpView extends GetView<TopUpController> {
  const TopUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TopUpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TopUpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
