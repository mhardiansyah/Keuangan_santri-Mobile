import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon List'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = controller.pokemonList[index];
            return ListTile(
              title: Text(pokemon.name.toUpperCase()),
              subtitle: Text(pokemon.url),
              leading: CircleAvatar(child: Text('${index + 1}')),
            );
          },
        );
      }),
    );
  }
}
