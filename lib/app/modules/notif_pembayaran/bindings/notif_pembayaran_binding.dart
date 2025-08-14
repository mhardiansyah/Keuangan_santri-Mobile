import 'package:get/get.dart';

import '../controllers/notif_pembayaran_controller.dart';

class NotifPembayaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifPembayaranController>(
      () => NotifPembayaranController(),
    );
  }
}
