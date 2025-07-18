import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() => TextFormField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      errorText: controller.nameError.value,
                    ),
                  )),
              Obx(() => TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: controller.emailError.value,
                    ),
                  )),
              Obx(() => TextFormField(
                    controller: controller.passwordController,
                    obscureText: controller.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: controller.passwordError.value,
                      suffixIcon: IconButton(
                        icon: Icon(controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  )),

              Obx(() => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      errorText: controller.confirmPasswordError.value,
                      suffixIcon: IconButton(
                        icon: Icon(controller.isConfirmPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  )),
               SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (controller.validateForm()) {
                    controller.register();
                  }
                },
                child:  Text('Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
