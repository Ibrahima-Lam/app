import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/coachs/coach.dart';
import 'package:fscore/models/participant.dart';
import 'package:fscore/pages/coach/widget_details/coach_fiche_list_widget.dart';
import 'package:fscore/pages/coach/widget_details/coach_game_list_widget.dart';
import 'package:fscore/pages/equipe/equipe_details.dart';
import 'package:fscore/providers/coach_provider.dart';
import 'package:fscore/providers/participant_provider.dart';
import 'package:fscore/widget/logos/coach_logo_widget.dart';
import 'package:fscore/widget/logos/equipe_logo_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';
import 'package:fscore/widget_pages/infos_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoachDetails extends StatelessWidget {
  final String id;
  CoachDetails({super.key, required this.id});

  late final Coach coach;

  late final Participant participant;

  final Set<String> tabs = {'Fiche', 'Matchs', 'Infos'};

  Map<String, Widget> get tabBarViewWidget => {
        'fiche': CoachFicheListWidget(coach: coach),
        'matchs': CoachGameListWidget(idCoach: id),
        'infos': InfosListWiget(categorieParams: CategorieParams(idCoach: id))
      };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: FutureBuilder(
        future: Future.wait([
          context.read<ParticipantProvider>().getParticipants(),
          context.read<CoachProvider>().getData(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: const Center(
                child: Text('erreur!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: const Center(child: CircularProgressIndicator()));
          }
          return Consumer2<CoachProvider, ParticipantProvider>(
            builder: (context, arb, part, child) {
              coach = arb.getCoach(id)!;
              participant = part.participants.firstWhere(
                  (element) => element.idParticipant == coach.idParticipant);
              return Scaffold(
                body: DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            centerTitle: true,
                            title: Text(
                              coach.nomCoach,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.person_2_rounded),
                              ),
                            ],
                            expandedHeight: 180,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 35),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EquipeDetails(
                                                          id: participant
                                                              .idParticipant))),
                                          child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: EquipeImageLogoWidget(
                                                url:
                                                    participant.imageUrl ?? ''),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: CoachImageLogoWidget(
                                            url: coach.imageUrl,
                                          ),
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
                          )
                        ];
                      },
                      body: TabBarView(
                          children: tabs
                              .map((e) =>
                                  tabBarViewWidget[e.toLowerCase()] ??
                                  const Center(
                                    child: Text('Page vide!'),
                                  ))
                              .toList())),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
