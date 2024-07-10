import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/models/competition.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/logos/arbitre_logo_widget.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:app/widget/fiches_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitreFicheListWidget extends StatelessWidget {
  final Arbitre arbitre;
  const ArbitreFicheListWidget({super.key, required this.arbitre});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FicheInfosWidget(
              categorieParams: CategorieParams(idArbitre: arbitre.idArbitre)),
          InformationArbitreWidget(arbitre: arbitre),
          FicheSponsorWidget(
              categorieParams: CategorieParams(idArbitre: arbitre.idArbitre)),
        ],
      ),
    );
  }
}

class InformationArbitreWidget extends StatelessWidget {
  final Arbitre arbitre;
  const InformationArbitreWidget({super.key, required this.arbitre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
          height: 300,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: ArbitreImageLogoWidget(url: arbitre.imageUrl),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            arbitre.nomArbitre,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            arbitre.role,
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
                    gradient: LinearGradient(colors: [
                      Colors.lightGreenAccent,
                      Colors.white,
                      Colors.yellowAccent
                    ]),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          '',
                        )),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Consumer<CompetitionProvider>(
                        builder: (context, val, child) {
                      if (val.collection.competitions.isEmpty)
                        return const SizedBox();
                      Competition competition = val.collection.competitions
                          .firstWhere((element) =>
                              element.codeEdition == arbitre.idEdition);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            SizedBox(
                                height: 50,
                                width: 50,
                                child: CompetitionImageLogoWidget(
                                    url: competition.imageUrl)),
                            SizedBox(width: 10),
                            Text(
                              competition.nomEdition ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
