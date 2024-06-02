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
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterProvider()),
        ChangeNotifierProvider(create: (context) => StatistiqueProvider()),
        ChangeNotifierProvider(create: (context) => CompetitionProvider()),
        ChangeNotifierProvider(create: (context) => GameProvider()),
        ChangeNotifierProvider(create: (context) => GameEventProvider()),
        ChangeNotifierProvider(create: (context) => GameEventListProvider()),
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
          primaryColor: Colors.green,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.green, foregroundColor: Colors.white),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Color(0xFFEDE7F6),
          cardTheme:
              CardTheme(color: Colors.white, surfaceTintColor: Colors.white),
          drawerTheme: DrawerThemeData(
              backgroundColor: Colors.white, surfaceTintColor: Colors.white),
          navigationBarTheme: NavigationBarThemeData(
            overlayColor: MaterialStatePropertyAll(Colors.green),
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
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(
        Icons.home,
        color: Colors.green,
      ),
      label: 'Match',
    ),
    const NavigationDestination(
      label: 'Infos',
      icon: Icon(Icons.info_outline),
      selectedIcon: Icon(
        Icons.info,
        color: Colors.green,
      ),
    ),
    const NavigationDestination(
      label: 'Explorer',
      icon: Icon(Icons.open_in_browser),
      selectedIcon: Icon(
        Icons.open_in_browser_sharp,
        color: Colors.green,
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
          child: const Icon(
            Icons.notifications,
            color: Colors.green,
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
        shadowColor: Colors.green,
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
