// viewModels/pokemon_viewmodel.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/models/pokemon_data.dart';
import '../data/repositories/pokemon_repository.dart';
import '../providers/pokemon_repository_provider.dart';

class PokemonState {
  final List<PokemonData> pokemons;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;

  PokemonState({
    required this.pokemons,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
  });

  PokemonState copyWith({
    List<PokemonData>? pokemons,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
  }) {
    return PokemonState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PokemonViewModel extends StateNotifier<PokemonState> {
  final PokemonRepository _repository;
  int _currentPage = 0;
  static const int _initialLoadSize = 100;
  static const int _pageSize = 20;
  bool _hasMore = true;

  PokemonViewModel(this._repository) : super(PokemonState(pokemons: [])) {
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final newPokemons = await _repository.fetchPokemons(
        offset: 0,
        limit: _initialLoadSize,
      );

      if (newPokemons.length < _initialLoadSize) {
        _hasMore = false;
      }

      _currentPage = (_initialLoadSize / _pageSize).floor();

      state = state.copyWith(
        pokemons: newPokemons,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMorePokemons() async {
    if (!_hasMore || state.isLoading) return;

    state = state.copyWith(isLoading: true);

    try {
      final newPokemons = await _repository.fetchPokemons(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (newPokemons.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
      }

      state = state.copyWith(
        pokemons: [...state.pokemons, ...newPokemons],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  void refresh() {
    _currentPage = 0;
    _hasMore = true;
    state = PokemonState(pokemons: []);
    _initialLoad();
  }
}

final pokemonViewModelProvider = StateNotifierProvider<PokemonViewModel, PokemonState>((ref) {
  return PokemonViewModel(ref.read(pokemonRepositoryProvider));
});
