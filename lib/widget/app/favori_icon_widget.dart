import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/providers/favori_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriIconWidget extends StatelessWidget {
  final String id;
  final Categorie categorie;

  const FavoriIconWidget(
      {super.key, required this.id, required this.categorie});

  @override
  Widget build(BuildContext context) {
    if (categorie == Categorie.competition)
      return CompetitionFavoriIconWidget(id: id);
    if (categorie == Categorie.equipe) return EquipeFavoriIconWidget(id: id);
    if (categorie == Categorie.joueur) return JoueurFavoriIconWidget(id: id);
    return IconWidget(favori: false);
  }
}

class IconWidget extends StatelessWidget {
  final bool favori;
  final Function()? onPressed;
  const IconWidget({super.key, required this.favori, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(favori ? Icons.star : Icons.star_outline),
    );
  }
}

class CompetitionFavoriIconWidget extends StatelessWidget {
  final String id;

  const CompetitionFavoriIconWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriProvider>(
      builder: (context, favoriProvider, child) {
        final bool favori = favoriProvider.competitions.any((e) => e == id);
        return IconWidget(
          favori: favori,
          onPressed: () {
            if (!favori)
              favoriProvider.addCompetition(id);
            else
              favoriProvider.deleteCompetition(id);
          },
        );
      },
    );
  }
}

class EquipeFavoriIconWidget extends StatelessWidget {
  final String id;

  const EquipeFavoriIconWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriProvider>(
      builder: (context, favoriProvider, child) {
        bool favori = favoriProvider.equipes.any((e) => e == id);
        return IconWidget(
          favori: favori,
          onPressed: () {
            if (!favori)
              favoriProvider.addEquipe(id);
            else
              favoriProvider.deleteEquipe(id);
          },
        );
      },
    );
  }
}

class JoueurFavoriIconWidget extends StatelessWidget {
  final String id;

  const JoueurFavoriIconWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriProvider>(
      builder: (context, favoriProvider, child) {
        bool favori = favoriProvider.joueurs.any((e) => e == id);
        return IconWidget(
          favori: favori,
          onPressed: () {
            if (!favori)
              favoriProvider.addJoueur(id);
            else
              favoriProvider.deleteJoueur(id);
          },
        );
      },
    );
  }
}
