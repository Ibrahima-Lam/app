import 'package:app/models/joueur.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurStatistiqueWidget extends StatelessWidget {
  final Joueur joueur;
  const JoueurStatistiqueWidget({super.key, required this.joueur});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('erreur!'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Consumer<GameEventListProvider>(
          builder: (context, value, child) {
            return Card();
          },
        );
      },
    );
  }
}
