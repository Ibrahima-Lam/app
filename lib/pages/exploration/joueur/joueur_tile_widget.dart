import 'package:fscore/models/joueur.dart';
import 'package:fscore/pages/exploration/rating_widget.dart';
import 'package:fscore/pages/joueur/joueur_details.dart';
import 'package:fscore/widget/logos/joueur_logo_widget.dart';
import 'package:flutter/material.dart';

abstract class JoueurSupTileWidget extends StatelessWidget {
  final Joueur joueur;
  const JoueurSupTileWidget({super.key, required this.joueur});

  void onTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => JoueurDetails(idJoueur: joueur.idJoueur)));
  }
}

class JoueurHorizontalTileWidget extends JoueurSupTileWidget {
  final bool back;

  const JoueurHorizontalTileWidget({
    super.key,
    required super.joueur,
    this.back = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(context),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: JoueurImageLogoWidget(url: joueur.imageUrl),
      ),
      title: Text(
        joueur.nomJoueur,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(),
      ),
      subtitle: RatingWidget(rating: joueur.rating, centered: false),
    );
  }
}

class JoueurVerticalTileWidget extends JoueurSupTileWidget {
  const JoueurVerticalTileWidget({super.key, required super.joueur});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => onTap(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            width: 130,
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: JoueurImageLogoWidget(url: joueur.imageUrl),
                ),
                Text(
                  joueur.nomJoueur,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                RatingWidget(rating: joueur.rating),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
