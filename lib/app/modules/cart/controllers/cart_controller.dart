import 'package:get/get.dart';
import 'package:sakusantri/app/core/models/cart_models.dart';
import 'package:sakusantri/app/core/models/items_model.dart';

class CartController extends GetxController {
  //TODO: Implement CartController

  final count = 0.obs;
  var cartItems = <CartModels>[].obs;

  @override
  void addCart(Items product) {
    int index = cartItems.indexWhere((e) => e.product.id == product.id);
    if (index >= 0) {
      cartItems[index].jumlah += 1;
    } else {
      cartItems.add(CartModels(product: product));
    }
  }

  void removeCart(Items product) {
    cartItems.removeWhere((e) => e.product.id == product.id);
  }

  void incjumlah(CartModels item) {
    item.jumlah += 1;
    cartItems.refresh();
  }

  void decjumlah(CartModels item) {
    if (item.jumlah > 1) {
      item.jumlah -= 1;
      cartItems.refresh();
    } else {
      // removeCart(item.product);
    }
  }

  void clear() {
    cartItems.clear();
  }

  int get totalHargaPokok =>
      cartItems.fold(0, (sum, item) => sum + item.jumlah * item.product.harga);

  int get pajak => (totalHargaPokok * 0.1).toInt();

  int get totalPembayaran => totalHargaPokok + pajak;

  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
