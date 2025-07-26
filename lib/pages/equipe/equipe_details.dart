// ignore_for_file: must_be_immutable

import 'package:fscore/collection/competition_collection.dart';
import 'package:fscore/core/enums/categorie_enum.dart';
import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/competition.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/pages/competition/competition_details.dart';
import 'package:fscore/pages/equipe/widget_details/equipe_fiche_list_widget.dart';
import 'package:fscore/pages/equipe/widget_details/game_list_widget.dart';
import 'package:fscore/pages/equipe/widget_details/joueur_delegate_search_widget.dart';
import 'package:fscore/pages/equipe/widget_details/effectif_widget.dart';
import 'package:fscore/pages/forms/joueur_form.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/providers/paramettre_provider.dart';
import 'package:fscore/providers/participant_provider.dart';
import 'package:fscore/widget/app/favori_icon_widget.dart';
import 'package:fscore/widget/classement/classement_widget.dart';
import 'package:fscore/pages/equipe/widget_details/equipe_statistiques_widget.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:fscore/widget/logos/equipe_logo_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget_pages/infos_list_widget.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquipeDetails extends StatelessWidget {
  final String id;
  EquipeDetails({super.key, required this.id});

  late final Participant participant;
  late final Competition competition;
  bool checkUser = false;

  static String CLASSEMENT = 'Classement';
  final Set<String> tabs = {
    'Fiche',
    'Match',
    CLASSEMENT,
    'infos',
    'Effectif',
    'Statistique',
  };

  Map<String, Widget> get tabBarViewWidgets => {
        'match': GameListWidget(idParticipant: id),
        'classement': ClassementWiget.equipe(
            idParticipant: id,
            codeEdition: participant.codeEdition,
            isTarget: true),
        'effectif':
            EffectifWidget(participant: participant, checkUser: checkUser),
        'infos': InfosListWiget(
          categorieParams: CategorieParams(idParticipant: id),
        ),
        'statistique': EquipeStatistiquesWidget(idParticipant: id),
        'fiche': EquipeFicheListWidget(participant: participant),
      };

  Future<bool> _getEquipe(BuildContext context) async {
    participant = await context.read<ParticipantProvider>().getParticipant(id);
    CompetitionCollection competitionCollection =
        await context.read<CompetitionProvider>().getCompetitions();
    competition = competitionCollection.getElementAt(participant.codeEdition);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: FutureBuilder(
          future: _getEquipe(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Erreur de chargement!'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Consumer<ParamettreProvider>(
                builder: (context, paramettreProvider, child) {
              checkUser = paramettreProvider.checkUser(participant.codeEdition);
              if (!competition.hasClassement) {
                tabs.remove(CLASSEMENT);
              }

              return DefaultTabController(
                length: tabs.length,
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          centerTitle: true,
                          pinned: true,
                          expandedHeight: 180,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.navigate_before),
                          ),
                          title: Text(
                            participant.nomEquipe,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          actions: [
                            FavoriIconWidget(
                                id: id, categorie: Categorie.equipe),
                            IconButton(
                                onPressed: () {
                                  showSearch(
                                      context: context,
                                      delegate: JoueurDelegateSearch(
                                          idParticipant: id));
                                },
                                icon: Icon(Icons.search)),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 35),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompetitionDetails(
                                                        id: competition
                                                            .codeEdition))),
                                        child: SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: CompetitionImageLogoWidget(
                                              url: competition.imageUrl ?? ''),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      EquipeImageLogoWidget(
                                        height: 65,
                                        width: 65,
                                        url: participant.imageUrl,
                                      ),
                                      const SizedBox(width: 20),
                                      CircleAvatar(
                                        radius: 20,
                                        child: Icon(Icons.house),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          bottom: TabBarWidget.build(
                              tabs: tabs.map((e) => Tab(text: e)).toList()),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: tabs
                          .map((e) =>
                              tabBarViewWidgets[e.toLowerCase()] ??
                              Center(
                                child: Text('page vide !'),
                              ))
                          .toList(),
                    ),
                  ),
                  floatingActionButton: checkUser
                      ? FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    JoueurForm(participant: participant)));
                          },
                          child: Icon(Icons.add),
                        )
                      : null,
                ),
              );
            });
          }),
    );
  }
}
