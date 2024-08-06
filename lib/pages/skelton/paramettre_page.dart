// ignore_for_file: must_be_immutable

import 'package:app/models/app_paramettre.dart';
import 'package:app/pages/forms/competition_form.dart';
import 'package:app/pages/skelton/sponsor_page.dart';
import 'package:app/providers/app_paramettre_provider.dart';
import 'package:app/providers/arbitre_provider.dart';
import 'package:app/providers/coach_provider.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/providers/sponsor_provider.dart';
import 'package:app/service/app_paramettre_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParamettrePage extends StatelessWidget {
  ParamettrePage({super.key});

  late AppParamettre paramettre;

  Future<void> _sendData() async {
    await AppParamettreService().setData(paramettre);
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final bool checkRootUser =
        context.read<ParamettreProvider>().checkRootUser();
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramettre'),
        actions: [
          if (checkRootUser) ParamettreMenuWidget(),
        ],
      ),
      body: FutureBuilder(
          future: AppParamettreService().getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Consumer<AppParamettreProvider>(
                builder: (context, appParamettreProvider, _) {
              paramettre = appParamettreProvider.appParamettre;
              return SingleChildScrollView(
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      Card(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Center(
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  OutlinedButton(
                                      onPressed: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await context
                                            .read<ParamettreProvider>()
                                            .getData(remote: true);
                                        await context
                                            .read<CompetitionProvider>()
                                            .getCompetitions(remote: true);
                                        await context
                                            .read<ParticipantProvider>()
                                            .getParticipants(remote: true);
                                        await context
                                            .read<GroupeProvider>()
                                            .getGroupes(remote: true);
                                        await context
                                            .read<ParticipationProvider>()
                                            .getParticipations(remote: true);
                                        await context
                                            .read<GameEventListProvider>()
                                            .getEvents(remote: true);
                                        await context
                                            .read<GameProvider>()
                                            .getGames(remote: true);
                                        await context
                                            .read<JoueurProvider>()
                                            .getJoueurs(remote: true);
                                        await context
                                            .read<CoachProvider>()
                                            .getData(remote: true);
                                        await context
                                            .read<ArbitreProvider>()
                                            .getData(remote: true);
                                        await context
                                            .read<InfosProvider>()
                                            .getInformations(remote: true);
                                        await context
                                            .read<SponsorProvider>()
                                            .getData(remote: true);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: Text(
                                          'Actualiser les Donnees en stock')),
                                  if (isLoading)
                                    const CircularProgressIndicator(),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Afficher le nom d\'utilisateur'),
                              Switch(
                                  splashRadius: 3,
                                  value: paramettre.showUserName,
                                  onChanged: (value) {
                                    setState(() {
                                      paramettre.showUserName = value;
                                      _sendData();
                                    });
                                  }),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              );
            });
          }),
    );
  }
}

class ParamettreMenuWidget extends StatelessWidget {
  const ParamettreMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Ajouter une compétition'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CompetitionForm()));
          },
        ),
        PopupMenuItem(
          child: Text('Paramettre des sponsors'),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SponsorPage()));
          },
        ),
      ],
    );
  }
}
