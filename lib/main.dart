import 'package:app/collection/composition_collection.dart';
import 'package:app/models/app_paramettre.dart';
import 'package:app/pages/actualite/infos_page.dart';
import 'package:app/pages/exploration/exploration_page.dart';
import 'package:app/pages/game/game_page.dart';
import 'package:app/pages/notification/notification_page.dart';
import 'package:app/providers/app_paramettre_provider.dart';
import 'package:app/providers/arbitre_provider.dart';
import 'package:app/providers/coach_provider.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/favori_provider.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/providers/score_provider.dart';
import 'package:app/providers/sponsor_provider.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/providers/statistique_future_provider.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/service/local_notification_service.dart';
import 'package:app/widget/skelton/drawer_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(LocalNotificationService().onMessage);
  runApp(const MyApp());
}

// final Color color = const Color(0xFF263238);
final Color color = const Color(0xFF1C2834);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CompetitionProvider()),
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'RobotoCondensed',
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: color,
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(color),
            )),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(color),
            )),
            primaryColor: color,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: color, foregroundColor: Colors.white),
            appBarTheme: AppBarTheme(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            // Color(0xFFEDE7F6) Color.fromARGB(255, 232, 232, 232)
            scaffoldBackgroundColor: Color.fromARGB(255, 232, 232, 232),
            cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: Colors.blue,
              elevation: 1,
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
            ),
            navigationBarTheme: NavigationBarThemeData(
              overlayColor: WidgetStatePropertyAll(color),
            ),
            popupMenuTheme: PopupMenuThemeData(
              surfaceTintColor: Colors.white,
              color: Colors.white,
            )),
        home: GlobalPage(),
      ),
    );
  }
}

class GlobalPage extends StatefulWidget {
  const GlobalPage({super.key});

  @override
  State<GlobalPage> createState() => _GlobalPageState();
}

final double size = 30;

class _GlobalPageState extends State<GlobalPage> {
  late Connectivity _connectivity;
  initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivity.checkConnectivity().then((value) {
      if (value.contains(ConnectivityResult.none)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: ListTile(
                leading: Icon(Icons.wifi_off),
                title: Text('Vous etes hors ligne !')),
            duration: const Duration(milliseconds: 5000),
          ),
        );
        _connectivity.onConnectivityChanged.listen((event) {
          if (event.contains(ConnectivityResult.none)) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.white,
                content: ListTile(
                    leading: Icon(Icons.wifi_off),
                    title: Text('Vous etes hors ligne !')),
                duration: const Duration(milliseconds: 5000),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.white,
                content: ListTile(
                    leading: Icon(Icons.wifi, color: Colors.green),
                    title: Text('Connexion retablie !')),
                duration: const Duration(milliseconds: 3000),
              ),
            );
            context
                .read<CompetitionProvider>()
                .getCompetitions(locale: true)
                .then((value) {
              context.read<GameProvider>().getGames(locale: true);
            });
          }
        });
      }
    });
  }

  dispose() {
    super.dispose();
  }

  int currentIndex = 0;
  List<Widget> destinations = [
    NavigationDestination(
      icon: Icon(
        Icons.home_outlined,
        size: size,
      ),
      selectedIcon: Icon(
        Icons.home,
        size: size,
        color: color,
      ),
      label: 'Match',
    ),
    NavigationDestination(
      label: 'Infos',
      icon: Icon(
        Icons.info_outline,
        size: size,
      ),
      selectedIcon: Icon(
        Icons.info,
        size: size,
        color: color,
      ),
    ),
    NavigationDestination(
      label: 'Explorer',
      icon: Icon(
        Icons.open_in_browser,
        size: size,
      ),
      selectedIcon: Icon(
        Icons.open_in_browser,
        size: size,
        color: color,
      ),
    ),
    NavigationDestination(
      label: 'Notification',
      icon: Badge(
          isLabelVisible: false,
          label: null,
          child: Icon(
            Icons.notifications_none,
            size: size,
          )),
      selectedIcon: Badge(
          isLabelVisible: false,
          label: null,
          child: Icon(
            Icons.notifications,
            size: size,
            color: color,
          )),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          List<Widget> pages = [
            GamePage(
              openDrawer: () => Scaffold.of(context).openDrawer(),
            ),
            InfosPage(
              openDrawer: () => Scaffold.of(context).openDrawer(),
            ),
            ExplorationPage(
              openDrawer: () => Scaffold.of(context).openDrawer(),
            ),
            NotificationPage(
              openDrawer: () => Scaffold.of(context).openDrawer(),
            )
          ];

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constraint.maxWidth > 800 ? 200 : 0),
            child: pages[currentIndex],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 10,
        overlayColor: WidgetStatePropertyAll(Colors.grey),
        shadowColor: color,
        indicatorColor: const Color(0xFFF5F5F5),
        destinations: destinations,
        animationDuration: const Duration(milliseconds: 200),
        selectedIndex: currentIndex,
        height: 65,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      drawer: DrawerWidget(),
    );
  }
}
