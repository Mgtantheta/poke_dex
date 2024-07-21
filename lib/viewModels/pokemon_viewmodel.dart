// viewmodels/pokemon_viewmodel.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/models/pokemon_data.dart';
import '../data/repositories/pokemon_repository.dart';
import '../providers/pokemon_repository_provider.dart';

class PokemonViewModel extends StateNotifier<List<PokemonData>> {
  final PokemonRepository _repository;

  PokemonViewModel(this._repository) : super([]);

  Future<void> loadPokemons() async {
    state = await _repository.fetchPokemons();
  }
}

final pokemonViewModelProvider = StateNotifierProvider((ref) =>
    PokemonViewModel(ref.read(pokemonRepositoryProvider)));
