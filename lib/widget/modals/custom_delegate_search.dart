import 'package:app/models/competition.dart';
import 'package:app/models/game.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/models/searchable.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/history_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/game/game_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDelegateSearch extends SearchDelegate {
  List<Searchable> liste = [];

  Future<List<Searchable>> getData(BuildContext context) async {
    if (liste.isNotEmpty) {
      return liste;
    }
    final List<Competition> comps =
        (await context.read<CompetitionProvider>().getCompetitions())
            .competitions;
    final List<Participant> participants =
        await context.read<ParticipantProvider>().getParticipants();

    final List<Joueur> joueurs =
        await context.read<JoueurProvider>().getJoueurs();
    liste = [...participants, ...comps, ...joueurs];
    return liste;
  }

  String filterFC(String text) {
    if (text.substring(0, 2).toUpperCase() == 'FC') {
      text = text.substring(3).replaceAll('  ', ' ');
    }
    return text;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isEmpty
        ? null
        : [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                buildSuggestions(context);
              },
            )
          ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.navigate_before),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Center(
      child: Text(''),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Searchable> data = query.isEmpty ? historyProvider.value : liste;
    final List<Searchable> elements = data.where(
      (element) {
        List<String> q = [];
        if (element is Competition) {
          q.add(element.nomCompetition);
        }
        if (element is Participant) {
          q.add(element.nomEquipe);
          q.add(element.libelleEquipe!);
        }
        if (element is Game) {
          q.add(element.home.nomEquipe);
          q.add(filterFC(element.home.nomEquipe));
          q.add(element.away.nomEquipe);
          q.add(filterFC(element.away.nomEquipe));
        }
        if (element is Joueur) {
          q.add(element.nomJoueur);
        }
        for (String v in q) {
          if (v.toUpperCase().contains(query.toUpperCase())) {
            return true;
          }
        }
        return false;
      },
    ).toList();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        child: FutureBuilder(
          future: getData(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur '),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: elements.isEmpty
                  ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(query.isEmpty
                            ? 'Taper votre recherche!'
                            : 'Pas de correspondance !'),
                      ),
                    )
                  : Column(
                      children: [
                        for (Searchable searchable in elements)
                          if (searchable is Competition)
                            competitionListTile(context, searchable)
                          else if (searchable is Participant)
                            equipeListTile(context, searchable)
                          else if (searchable is Joueur)
                            joueurListTile(context, searchable)
                          else if (searchable is Game)
                            GameWidget(game: searchable)
                          else
                            const ListTile(),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget competitionListTile(BuildContext context, Competition competition) {
    return ListTile(
      leading: query.isEmpty
          ? const Icon(Icons.timer_outlined)
          : const Icon(Icons.search),
      title: Text(competition.nomCompetition),
      subtitle: const Text('competition'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CompetitionDetails(id: competition.codeEdition)));
        insertIntoHistoryProvider(competition);
        query = competition.nomCompetition;
        buildResults(context);
      },
    );
  }

  Widget equipeListTile(BuildContext context, Participant participant) {
    return ListTile(
      leading: query.isEmpty
          ? const Icon(Icons.timer_outlined)
          : const Icon(Icons.search),
      title: Text(participant.nomEquipe),
      subtitle: const Text('equipe'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                EquipeDetails(id: participant.idParticipant)));
        insertIntoHistoryProvider(participant);
        query = participant.nomEquipe;
        buildResults(context);
      },
    );
  }

  Widget joueurListTile(BuildContext context, Joueur joueur) {
    return ListTile(
      leading: query.isEmpty
          ? const Icon(Icons.timer_outlined)
          : const Icon(Icons.search),
      title: Text(joueur.nomJoueur),
      subtitle: const Text('joueur'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JoueurDetails(idJoueur: joueur.idJoueur)));
        insertIntoHistoryProvider(joueur);
        query = joueur.nomJoueur;
        buildResults(context);
      },
    );
  }

  void insertIntoHistoryProvider(Searchable searchable) {
    if (searchable is Participant) {
      historyProvider.value.retainWhere((element) {
        if (element is! Participant) return true;
        return element.idParticipant != searchable.idParticipant;
      });
      historyProvider.value.insert(0, searchable);
    }
    if (searchable is Competition) {
      historyProvider.value.retainWhere((element) {
        if (element is! Competition) return true;
        return element.codeEdition != searchable.codeEdition;
      });
      historyProvider.value.insert(0, searchable);
    }
    if (searchable is Joueur) {
      historyProvider.value.retainWhere((element) {
        if (element is! Joueur) return true;
        return element.idJoueur != searchable.idJoueur;
      });
      historyProvider.value.insert(0, searchable);
    }
  }
}
