// providers.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/repositories/pokemon_repository.dart';

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepositoryImpl();
});
