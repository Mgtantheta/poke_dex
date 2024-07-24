// lib/data/models/pokemon_data.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_data.freezed.dart';
part 'pokemon_data.g.dart';

@freezed
class PokemonData with _$PokemonData {
  const factory PokemonData({
    required int id,
    required String name,
    required String url,
    required String imageUrl,
  }) = _PokemonData;

  factory PokemonData.fromJson(Map<String, dynamic> json) => _$PokemonDataFromJson(json);
}
