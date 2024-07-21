// repositories/pokemon_repository.dart
import 'package:dio/dio.dart';
import '../models/pokemon_data.dart';

abstract class PokemonRepository {
  Future<List<PokemonData>> fetchPokemons();
}

class PokemonRepositoryImpl implements PokemonRepository {
  final Dio _dio = Dio();

  @override
  Future<List<PokemonData>> fetchPokemons() async {
    final response = await _dio.get('https://pokeapi.co/api/v2/pokemon');
    return (response.data['results'] as List)
        .map((json) => PokemonData.fromJson(json))
        .toList();
  }
}
