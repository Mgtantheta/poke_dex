// repositories/pokemon_repository.dart
import 'package:dio/dio.dart';
import '../models/pokemon_data.dart';

abstract class PokemonRepository {
  Future<List<PokemonData>> fetchPokemons({int offset = 0, int limit = 20});
}

class PokemonRepositoryImpl implements PokemonRepository {
  final Dio _dio = Dio();

  @override
  Future<List<PokemonData>> fetchPokemons({int offset = 0, int limit = 20}) async {
    try {
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );
      final List<dynamic> results = response.data['results'] as List<dynamic>;

      List<PokemonData> pokemons = [];

      for (var pokemon in results) {
        try {
          final detailResponse = await _dio.get(pokemon['url'] as String);
          final data = detailResponse.data;

          pokemons.add(PokemonData(
            id: data['id'] as int,
            name: data['name'] as String,
            imageUrl: data['sprites']['front_default'] as String, url: '',
          ));
        } catch (e) {
          print('Error fetching details for ${pokemon['name']}: $e');
          continue;
        }
      }

      return pokemons;
    } catch (e) {
      print('Error fetching pokemon list: $e');
      rethrow;
    }
  }
}
