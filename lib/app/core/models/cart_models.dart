import 'package:sakusantri/app/core/models/items_model.dart';

class CartModels {
  final Items product;
  int jumlah;
  CartModels({
    required this.product,
    this.jumlah = 1,
  });

  factory CartModels.fromJson(Map<String, dynamic> json) {
    return CartModels(
      product: Items.fromJson(json['product']),
      jumlah: json['jumlah'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'jumlah': jumlah,
    };
  }
}