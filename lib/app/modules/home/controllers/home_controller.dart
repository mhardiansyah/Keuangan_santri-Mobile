import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    final allProducts = [
      Product(name: 'Roti aoka rasa strawberry', price: 3000, stock: 9, category: 'Food'),
      Product(name: 'Sosis Kimbo', price: 6000, stock: 9, category: 'Food'),
      Product(name: 'Roti aoka rasa Mangga', price: 3000, stock: 9, category: 'Food'),
      Product(name: 'Sosis So nice', price: 1000, stock: 9, category: 'Food'),
      Product(name: 'Pulpen Faster', price: 2500, stock: 12, category: 'ATK'),
      Product(name: 'Sabun Lifebuoy', price: 5000, stock: 15, category: 'Sabun'),
    ];

    pokemonList.assignAll(allProducts);
    filterProducts();
    isLoading.value = false;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  void searchProduct(String keyword) {
    filterProducts(keyword: keyword);
  }

  void filterProducts({String keyword = ''}) {
    final filtered = pokemonList.where((product) {
      final matchesCategory = product.category == selectedCategory.value;
      final matchesSearch = product.name.toLowerCase().contains(keyword.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    filteredProductList.assignAll(filtered);
  }
}
