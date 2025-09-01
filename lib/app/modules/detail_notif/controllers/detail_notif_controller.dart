import 'package:get/get.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';

class DetailNotifController extends GetxController {
  late Notifikasi notif;

  @override
  void onInit() {
    super.onInit();
    notif = Get.arguments as Notifikasi;
  }
}
