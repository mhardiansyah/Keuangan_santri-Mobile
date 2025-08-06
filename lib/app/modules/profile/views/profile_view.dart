import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakusantri/app/modules/home/views/home_view.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1220),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => HomeView(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0E1220),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child:
                  isLandscape
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                profileAvatar(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(flex: 2, child: buildFormSection()),
                        ],
                      )
                      : Column(
                        children: [
                          const SizedBox(height: 20),
                          profileAvatar(),
                          const SizedBox(height: 32),
                          buildFormSection(),
                        ],
                      ),
            ),
          );
        },
      ),
    );
  }

  Widget profileAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextField(
          label: 'Nama:',
          hintText: 'Faqih Abqory',
          icon: Icons.edit,
          isPassword: false,
        ),
        const SizedBox(height: 16),
        buildTextField(
          label: 'Email:',
          hintText: 'Qoy123@gmail.com',
          icon: Icons.email,
          isPassword: false,
        ),
        const SizedBox(height: 16),
        buildTextField(
          label: 'Password',
          hintText: '**********',
          icon: Icons.visibility_off,
          isPassword: true,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              controller.logout();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: const Color(0xFFF4F2F2),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }
}
