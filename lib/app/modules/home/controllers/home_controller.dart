import 'dart:convert';

import 'package:get/get.dart';
import 'package:sakusantri/app/core/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  var pokemonList = <Pokemon>[].obs;
  var isLoading = true.obs;
  @override

   Future<void> fetchPokemonList() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];

        pokemonList.value = results.map((e) => Pokemon.fromJson(e)).toList();
      } else {
        print('Error status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onInit() {
    super.onInit();
    fetchPokemonList();
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
