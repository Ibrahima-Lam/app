import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fscore/core/constants/app/styles.dart';
import 'package:fscore/core/constants/navigation/kdestination.dart';
import 'package:fscore/core/route/app_route.dart';
import 'package:fscore/core/widget/multi_provider_widget.dart';
import 'package:fscore/pages/actualite/infos_page.dart';
import 'package:fscore/pages/exploration/exploration_page.dart';
import 'package:fscore/pages/game/game_page.dart';
import 'package:fscore/pages/notification/notification_page.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/core/service/local_notification_service.dart';
import 'package:fscore/widget/skelton/drawer_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        LocalNotificationService().showNotification(
          title: message.notification!.title ?? '',
          description: message.notification!.body ?? '',
          data: message.data,
        );
      }
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProviderWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: appRoutes,
        title: 'Football Score',
        theme: ThemeData(
            fontFamily: 'RobotoCondensed',
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: kColor,
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(kColor),
            )),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(kColor),
            )),
            primaryColor: kColor,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: kColor, foregroundColor: Colors.white),
            appBarTheme: AppBarTheme(
              backgroundColor: kColor,
              foregroundColor: Colors.white,
            ),
            // Color(0xFFEDE7F6) Color.fromARGB(255, 232, 232, 232)
            scaffoldBackgroundColor: Color.fromARGB(255, 232, 232, 232),
            cardTheme: CardThemeData(
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
              overlayColor: WidgetStatePropertyAll(kColor),
            ),
            popupMenuTheme: PopupMenuThemeData(
              surfaceTintColor: Colors.white,
              color: Colors.white,
            )),
        home: Scaffold(
          body: LayoutBuilder(builder: (context, constraint) {
            return LayoutBuilderWidget(
              child: GlobalPage(
                maxWidth: constraint.maxWidth,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class GlobalPage extends StatefulWidget {
  final double maxWidth;
  const GlobalPage({super.key, required this.maxWidth});

  @override
  State<GlobalPage> createState() => _GlobalPageState();
}

class _GlobalPageState extends State<GlobalPage> {
  bool versionChecked = true;

  Future<void> _checkVersion() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 10),
    ));
    await remoteConfig.fetchAndActivate();

    final minVersion = remoteConfig.getString('version');
    final currentVersion = (await PackageInfo.fromPlatform()).version;
    print(
        'Current version: $currentVersion, Minimum required version: $minVersion');

    if (_isVersionLower(currentVersion, minVersion)) {
      _showUpdateDialog();
    }
  }

  bool _isVersionLower(String current, String min) {
    List<int> c = current.split('.').map(int.parse).toList();
    List<int> m = min.split('.').map(int.parse).toList();
    for (int i = 0; i < m.length; i++) {
      if (c[i] < m[i]) return true;
      if (c[i] > m[i]) return false;
    }
    return false;
  }

  void _showUpdateDialog() {
    setState(() {
      versionChecked = false;
    });
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text("Mise à jour requise"),
            content:
                Text("Veuillez mettre à jour l'application pour continuer."),
            actions: [
              if (Platform.isAndroid)
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.fscore.app'));
                  },
                  child: Text("Google Play Store"),
                ),
              if (Platform.isAndroid)
                TextButton(
                  onPressed: () {
                    launchUrl(
                        Uri.parse('https://apkpure.com/p/com.fscore.app'));
                  },
                  child: Text("APKPure"),
                ),
              if (Platform.isIOS)
                TextButton(
                  onPressed: () {
                    launchUrl(
                        Uri.parse('https://apps.apple.com/app/id6444228700'));
                  },
                  child: Text("App Store"),
                ),
            ],
          ),
        );
    }
    ;
  }

  late Connectivity _connectivity;
  initState() {
    super.initState();
    if (!kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkVersion();
      });
      FirebaseMessaging.instance.subscribeToTopic('messages');
    }
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

  @override
  void dispose() {
    super.dispose();
  }

  int currentIndex = 0;
  bool get checkPlatform {
    if (kIsWeb) {
      return false;
    } else {
      return widget.maxWidth > 800 &&
          (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !versionChecked
          ? Center(child: SizedBox())
          : Builder(
              builder: (context) {
                List<Widget> pages = [
                  GamePage(
                    checkPlatform: checkPlatform,
                    openDrawer: () => Scaffold.of(context).openDrawer(),
                  ),
                  InfosPage(
                    checkPlatform: checkPlatform,
                    openDrawer: () => Scaffold.of(context).openDrawer(),
                  ),
                  ExplorationPage(
                    checkPlatform: checkPlatform,
                    openDrawer: () => Scaffold.of(context).openDrawer(),
                  ),
                  NotificationPage(
                    checkPlatform: checkPlatform,
                    openDrawer: () => Scaffold.of(context).openDrawer(),
                  )
                ];

                return pages[currentIndex];
              },
            ),
      bottomNavigationBar: checkPlatform
          ? null
          : NavigationBar(
              elevation: 10,
              overlayColor: WidgetStatePropertyAll(Colors.grey),
              shadowColor: kColor,
              indicatorColor: const Color(0xFFF5F5F5),
              destinations: kDestinations
                  .map((e) => NavigationDestination(
                        icon: e['icon'],
                        selectedIcon: e['selectedIcon'],
                        label: e['label'],
                      ))
                  .toList(),
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
      drawer: checkPlatform ? null : DrawerWidget(checkPlatform: checkPlatform),
    );
  }
}
