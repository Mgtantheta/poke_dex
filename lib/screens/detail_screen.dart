import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Pokémon Detail')),
      body: ElevatedButton(
        child: const Text("ホーム画面へ戻る"),
        onPressed: () {
          context.pop();
        },
      ),
    );
  }
}
