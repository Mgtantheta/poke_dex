import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../viewModels/pokemon_viewmodel.dart';

class PokemonListScreen extends HookConsumerWidget {
  const PokemonListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonState = ref.watch(pokemonViewModelProvider);
    final scrollController = useScrollController();

    useEffect(() {
      void listener() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          ref.read(pokemonViewModelProvider.notifier).loadMorePokemons();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(title: const Text('Poké Dex')),
      body: pokemonState.hasError
          ? Center(child: Text('Error: ${pokemonState.errorMessage}'))
          : pokemonState.pokemons.isEmpty
          ? Center(
        child: pokemonState.isLoading
            ? const CircularProgressIndicator()
            : const Text('No Pokémon available'),
      )
          : ListView.builder(
        controller: scrollController,
        itemCount: pokemonState.pokemons.length + (pokemonState.isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == pokemonState.pokemons.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final pokemon = pokemonState.pokemons[index];
          return ListTile(
            title: Text(pokemon.name),
            leading: Image.network(
              pokemon.imageUrl,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error),
              loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : const CircularProgressIndicator(),
            ),
            subtitle: Text('ID: ${pokemon.id}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(pokemonViewModelProvider.notifier).refresh(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
