import 'package:flutter/material.dart';

class TabBarWidget {
  static PreferredSizeWidget build({
    TabController? controller,
    required List<Widget> tabs,
    TabAlignment? tabAlignment,
    Function(int)? onTap,
  }) {
    return TabBar(
      onTap: onTap,
      controller: controller,
      indicatorColor: Colors.white,
      indicatorPadding: const EdgeInsets.only(top: 1, bottom: 2),
      isScrollable: true,
      unselectedLabelStyle: const TextStyle(
        color: Color.fromARGB(176, 255, 255, 255),
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      tabAlignment: tabAlignment ?? TabAlignment.start,
      tabs: tabs,
    );
  }
}
