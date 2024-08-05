import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/pokemon_list_screen.dart';
import '../screens/detail_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/pokemonListScreen',
  routes: <RouteBase>[
    GoRoute(
      path: '/pokemonListScreen',
      builder: (context, state) => const PokemonListScreen(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) => const DetailScreen(),
        ),
      ],
    )
  ],
);
