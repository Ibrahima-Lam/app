import 'package:flutter/material.dart';
import 'package:fscore/collection/composition_collection.dart';
import 'package:fscore/models/app_paramettre.dart';
import 'package:fscore/providers/app_paramettre_provider.dart';
import 'package:fscore/providers/arbitre_provider.dart';
import 'package:fscore/providers/coach_provider.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/providers/composition_provider.dart';
import 'package:fscore/providers/favori_provider.dart';
import 'package:fscore/providers/fixture_provider.dart';
import 'package:fscore/providers/game_event_list_provider.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/providers/groupe_provider.dart';
import 'package:fscore/providers/infos_provider.dart';
import 'package:fscore/providers/joueur_provider.dart';
import 'package:fscore/providers/notification_provider.dart';
import 'package:fscore/providers/paramettre_provider.dart';
import 'package:fscore/providers/participant_provider.dart';
import 'package:fscore/providers/participation_provider.dart';
import 'package:fscore/providers/score_provider.dart';
import 'package:fscore/providers/sponsor_provider.dart';
import 'package:fscore/providers/statistique_future_provider.dart';
import 'package:fscore/providers/statistique_provider.dart';
import 'package:fscore/providers/user_provider.dart';
import 'package:fscore/service/fixture_service.dart';
import 'package:fscore/service/notification_service.dart';
import 'package:provider/provider.dart';

class MultiProviderWidget extends StatelessWidget {
  final Widget child;
  const MultiProviderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CompetitionProvider()),
        ChangeNotifierProvider(
            create: (context) => NotificationProvider(NotificationService())),
        ChangeNotifierProvider(
          create: (context) => FavoriProvider()
            ..getCompetitions()
            ..getEquipes()
            ..getJoueurs(),
          lazy: false,
        ),
        ChangeNotifierProvider(
            lazy: false,
            create: (context) =>
                AppParamettreProvider(appParamettre: AppParamettre())
                  ..getData()),
        ChangeNotifierProvider(
            lazy: false,
            create: (context) => ParticipantProvider()..initParticipants()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => ScoreProvider([]),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => SponsorProvider([]),
        ),
        ChangeNotifierProvider(
            lazy: false, create: (context) => InfosProvider()),
        ChangeNotifierProvider(create: (context) => CoachProvider()),
        ChangeNotifierProvider(create: (context) => ArbitreProvider()),
        ChangeNotifierProvider(
            create: (context) => FixtureProvider(FixtureService())),
        ChangeNotifierProvider(
            lazy: false, create: (context) => GroupeProvider()),
        ChangeNotifierProvider<GameEventListProvider>(
          lazy: false,
          create: (context) => GameEventListProvider([])..getEvents(),
        ),
        ChangeNotifierProxyProvider4<ParticipantProvider, GameEventListProvider,
                GroupeProvider, ScoreProvider, GameProvider>(
            lazy: false,
            create: (context) => GameProvider([],
                scoreProvider: context.read<ScoreProvider>(),
                participantProvider: ParticipantProvider(),
                gameEventListProvider: GameEventListProvider([]),
                groupeProvider: GroupeProvider([])),
            update: (context, parts, events, groupes, scores, previous) =>
                GameProvider(
                  previous?.games ?? [],
                  scoreProvider: scores,
                  participantProvider: parts,
                  gameEventListProvider: events,
                  groupeProvider: groupes,
                )),
        ChangeNotifierProxyProvider2<ParticipantProvider, GroupeProvider,
                ParticipationProvider>(
            create: (context) => ParticipationProvider([],
                participantProvider: context.read<ParticipantProvider>(),
                groupeProvider: context.read<GroupeProvider>()),
            update: (context, parts, groupes, previous) =>
                ParticipationProvider(
                  previous?.participations ?? [],
                  participantProvider: parts,
                  groupeProvider: groupes,
                )),
        ChangeNotifierProvider<StatistiqueFutureProvider>(
          lazy: false,
          create: (context) => StatistiqueFutureProvider([]),
        ),
        ChangeNotifierProxyProvider2<StatistiqueFutureProvider,
            GameEventListProvider, StatistiqueProvider>(
          create: (context) => StatistiqueProvider(
              context.read<StatistiqueFutureProvider>(),
              context.read<GameEventListProvider>()),
          update: (context, stats, events, previous) =>
              StatistiqueProvider(stats, events),
        ),
        ChangeNotifierProxyProvider<UserProvider, ParamettreProvider>(
            lazy: false,
            create: (context) =>
                ParamettreProvider(userProvider: context.read<UserProvider>()),
            update: (context, value, previous) =>
                ParamettreProvider(userProvider: value)),
        ChangeNotifierProxyProvider<ParticipantProvider, JoueurProvider>(
            lazy: false,
            create: (context) => JoueurProvider([],
                participantProvider: context.read<ParticipantProvider>()),
            update: (context, value, previous) => JoueurProvider(
                previous?.joueurs ?? [],
                participantProvider: value)),
        ChangeNotifierProxyProvider<GameEventListProvider, CompositionProvider>(
            lazy: false,
            create: (context) => CompositionProvider(
                compositionCollection: CompositionCollection([]),
                gameEventListProvider: context.read<GameEventListProvider>()),
            update: (context, value, previous) => CompositionProvider(
                compositionCollection: previous?.compositionCollection ??
                    CompositionCollection([]),
                gameEventListProvider: value)),
      ],
      child: child,
    );
  }
}
