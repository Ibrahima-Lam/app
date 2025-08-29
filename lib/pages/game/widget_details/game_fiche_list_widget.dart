import 'package:fscore/core/class/abbreviable.dart';
import 'package:fscore/core/extension/string_extension.dart';
import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/game.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/widget/fiche/fiches_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameFicheListWidget extends StatelessWidget {
  final String idGame;
  const GameFicheListWidget({super.key, required this.idGame});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          cardTheme: CardThemeData(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FicheInfosWidget(
              categorieParams: CategorieParams(idGame: idGame),
            ),
            InformationGameWidget(idGame: idGame),
            FicheSponsorWidget(
              categorieParams: CategorieParams(idGame: idGame),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class InformationGameWidget extends StatelessWidget with Abbreviable {
  final String idGame;
  InformationGameWidget({super.key, required this.idGame});
  Game? game;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(builder: (context, val, child) {
      try {
        game = val.games.firstWhere((element) => element.idGame == idGame);
      } catch (e) {
        game = null;
      }
      if (game == null) return const SizedBox();
      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Card(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.sports_soccer,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              (game?.niveau.nomNiveau ?? '').capitalize(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              abbr(game?.home.nomEquipe ?? '') +
                                  (' vs ') +
                                  abbr(game?.away.nomEquipe ?? ''),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Todo
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(child: Text('Ajouter au favori')),
                        PopupMenuItem(child: Text('Voir plus')),
                        PopupMenuItem(child: Text('Contacter')),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 5.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'images/stade2.png',
                          )),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          spacing: 5.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.place),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(game?.stadeGame ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.calendar_month),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(game?.dateGame ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.timer),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(game?.heureGame ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
