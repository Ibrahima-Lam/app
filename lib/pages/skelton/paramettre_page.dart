// ignore_for_file: must_be_immutable

import 'package:app/models/app_paramettre.dart';
import 'package:app/models/groupe.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/forms/competition_form.dart';
import 'package:app/pages/skelton/sponsor_page.dart';
import 'package:app/providers/app_paramettre_provider.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/service/app_paramettre_service.dart';
import 'package:app/service/arbitre_service.dart';
import 'package:app/service/coach_service.dart';
import 'package:app/service/competition_service.dart';
import 'package:app/service/game_service.dart';
import 'package:app/service/groupe_service.dart';
import 'package:app/service/infos_service.dart';
import 'package:app/service/joueur_service.dart';
import 'package:app/service/paramettre_service.dart';
import 'package:app/service/participant_service.dart';
import 'package:app/service/participation_service.dart';
import 'package:app/service/sponsor_service.dart';
import 'package:app/widget/skelton/layout_builder_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    return LayoutBuilderWidget(
      child: Scaffold(
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
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    OutlinedButton(
                                        onPressed: () async {
                                          if ((await Connectivity()
                                                  .checkConnectivity())
                                              .contains(
                                                  ConnectivityResult.none)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Vous etes hors ligne !'),
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                              ),
                                            );
                                            return;
                                          }

                                          setState(() {
                                            isLoading = true;
                                          });
                                          await ParamettreService
                                              .getRemoteData();
                                          await CompetitionService()
                                              .getRemoteData();
                                          List<Participant> participants =
                                              await ParticipantService
                                                  .getRemoteData();
                                          List<Groupe> groupes =
                                              await GroupeService
                                                  .getRemoteData();
                                          await ParticipationService
                                              .getRemoteData(
                                                  participants, groupes);
                                          await GameService().getRemoteData(
                                              participants, groupes);
                                          await JoueurService.getRemoteData(
                                              participants);
                                          await CoachService.getRemoteData();
                                          await ArbitreService.getRemoteData();
                                          await InfosService.getRemoteData();
                                          await SponsorService.getRemoteData();

                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                        child: Text('Actualiser')),
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
      ),
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
