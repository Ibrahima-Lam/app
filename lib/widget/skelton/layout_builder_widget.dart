import 'dart:io';

import 'package:app/core/constants/navigation/kdestination.dart';
import 'package:app/pages/actualite/infos_page.dart';
import 'package:app/pages/exploration/exploration_page.dart';
import 'package:app/pages/game/game_page.dart';
import 'package:app/pages/notification/notification_page.dart';
import 'package:app/widget/skelton/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LayoutBuilderWidget extends StatefulWidget {
  final Widget child;

  const LayoutBuilderWidget({super.key, required this.child});

  @override
  State<LayoutBuilderWidget> createState() => _LayoutBuilderWidgetState();
}

class _LayoutBuilderWidgetState extends State<LayoutBuilderWidget> {
  final double maxWidth = 800;
  int selectedIndex = 0;

  late Widget child;
  @override
  initState() {
    super.initState();
    child = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        bool isDesktop = false;
        if (kIsWeb) {
          isDesktop = false;
        } else {
          isDesktop =
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
        }

        bool checkPlatform = constraint.maxWidth > maxWidth && isDesktop;

        final List<Widget> pages = [
          GamePage(checkPlatform: checkPlatform, openDrawer: () => null),
          InfosPage(checkPlatform: checkPlatform, openDrawer: () => null),
          ExplorationPage(checkPlatform: checkPlatform, openDrawer: () => null),
          NotificationPage(
            checkPlatform: checkPlatform,
            openDrawer: () => null,
          ),
        ];
        return checkPlatform
            ? Scaffold(
                body: Row(
                  children: [
                    NavigationRailWidget(
                      selectedIndex: selectedIndex,
                      onSelectedIndexChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                          child = pages[value];
                        });
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .20,
                      child: DrawerWidget(
                        checkPlatform: checkPlatform,
                        showUser: false,
                        isSideBar: true,
                      ),
                    ),
                    Expanded(child: child),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .03,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            : Padding(
                padding: constraint.maxWidth > maxWidth
                    ? EdgeInsets.symmetric(
                        horizontal: constraint.maxWidth * .14,
                      )
                    : EdgeInsets.zero,
                child: widget.child,
              );
      },
    );
  }
}

class NavigationRailWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelectedIndexChanged;
  const NavigationRailWidget({
    super.key,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      destinations: kDestinations
          .map(
            (e) => NavigationRailDestination(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              icon: e['icon'],
              selectedIcon: e['selectedIcon'],
              label: Text(e['label']),
            ),
          )
          .toList(),
      selectedIndex: selectedIndex,
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 10,
      indicatorColor: const Color(0xFFCDCDCD),
      onDestinationSelected: onSelectedIndexChanged,
    );
  }
}
