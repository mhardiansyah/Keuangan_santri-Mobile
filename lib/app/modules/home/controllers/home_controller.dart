import 'package:get/get.dart';
import 'package:sakusantri/app/core/models/items_model.dart';

class Product {
  final String name;
  final int price;
  final int stock;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
  });
}

class HomeController extends GetxController {
  var isLoading = true.obs;
  var pokemonList = <Product>[].obs;
  var filteredProductList = <Product>[].obs;
  var selectedCategory = 'Food'.obs;
  var itemsList = <Items>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
  
}
