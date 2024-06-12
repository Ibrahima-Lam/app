import 'package:app/pages/actualite/infos_page.dart';
import 'package:app/pages/exploration/exploration_page.dart';
import 'package:app/pages/game/game_page.dart';
import 'package:app/pages/notification/notification_page.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/providers/counter_provider.dart';
import 'package:app/providers/game_event_list_provider.dart';
import 'package:app/providers/game_event_provider.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/providers/participation_provider.dart';
import 'package:app/providers/statistique_future_provider.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final Color color = const Color(0xFF263238);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterProvider()),
        ChangeNotifierProvider<GameEventListProvider>(
          lazy: false,
          create: (context) => GameEventListProvider([]),
        ),
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
        ChangeNotifierProvider(create: (context) => CompetitionProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => GameEventProvider()),
        ChangeNotifierProvider(create: (context) => GroupeProvider()),
        ChangeNotifierProvider(create: (context) => ParticipantProvider()),
        ChangeNotifierProvider(create: (context) => ParticipationProvider()),
        ChangeNotifierProvider(create: (context) => InfosProvider()),
        ChangeNotifierProvider(create: (context) => CompositionProvider()),
        ChangeNotifierProvider(create: (context) => JoueurProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(),

          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: color,
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(color),
          )),
          primaryColor: color,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: color, foregroundColor: Colors.white),
          appBarTheme: AppBarTheme(
            backgroundColor: color,
            foregroundColor: Colors.white,
          ),
          // Color(0xFFEDE7F6)
          scaffoldBackgroundColor: Color.fromARGB(255, 236, 232, 232),
          cardTheme:
              CardTheme(color: Colors.white, surfaceTintColor: Colors.white),
          drawerTheme: DrawerThemeData(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          navigationBarTheme: NavigationBarThemeData(
            overlayColor: MaterialStatePropertyAll(color),
          ),
        ),
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

class _GlobalPageState extends State<GlobalPage> {
  int currentIndex = 0;
  List<Widget> destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(
        Icons.home,
        color: color,
      ),
      label: 'Match',
    ),
    NavigationDestination(
      label: 'Infos',
      icon: Icon(Icons.info_outline),
      selectedIcon: Icon(
        Icons.info,
        color: color,
      ),
    ),
    NavigationDestination(
      label: 'Explorer',
      icon: Icon(Icons.open_in_browser),
      selectedIcon: Icon(
        Icons.open_in_browser_sharp,
        color: color,
      ),
    ),
    NavigationDestination(
      label: 'Notification',
      icon: Badge(
          isLabelVisible: false,
          label: null,
          child: const Icon(Icons.notifications_none)),
      selectedIcon: Badge(
          isLabelVisible: false,
          label: null,
          child: Icon(
            Icons.notifications,
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
        elevation: 5,
        shadowColor: color,
        indicatorColor: Colors.white,
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
