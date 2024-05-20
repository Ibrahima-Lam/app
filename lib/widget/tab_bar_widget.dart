import 'package:flutter/material.dart';

class TabBarWidget {
  static PreferredSizeWidget build({
    TabController? controller,
    required List<Widget> tabs,
    Function(int)? onTap,
  }) {
    return TabBar(
      onTap: onTap,
      controller: controller,
      indicatorColor: Colors.white,
      indicatorPadding: const EdgeInsets.symmetric(vertical: 2),
      isScrollable: true,
      unselectedLabelStyle: const TextStyle(
        color: Color.fromARGB(176, 255, 255, 255),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      tabAlignment: TabAlignment.start,
      tabs: tabs,
    );
  }
}
