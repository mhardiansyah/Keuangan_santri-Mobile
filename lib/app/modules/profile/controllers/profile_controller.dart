import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var profileImageUrl = ''.obs;
  var name = 'Santri Pintar'.obs;
  var email = 'santri@email.com'.obs;
  var password = '123456'.obs;
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void logout() {
    // logika logout
    final box = GetStorage();
    box.erase();
    Get.offAllNamed('/login');
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  void fetchProfileData() async {
    // Simulasi fetch dari backend/database
    await Future.delayed(const Duration(seconds: 1));
    profileImageUrl.value =
        'https://i.pravatar.cc/150?img=12'; // ganti dengan URL gambar dari backend kamu
    name.value = 'Muhammad Hardiansyah';
    email.value = 'hardiansyah@gmail.com';
    password.value = 'rahasia123';
  }
}
