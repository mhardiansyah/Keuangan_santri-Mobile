import 'package:sakusantri/app/core/models/items_model.dart';

class CartModels {
  final Items product;
  int jumlah;
  CartModels({
    required this.product,
    this.jumlah = 1,
  });

  
}
