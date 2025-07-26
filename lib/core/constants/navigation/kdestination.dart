import 'package:fscore/core/constants/app/styles.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> kDestinations = [
  {
    'label': 'Match',
    'icon': Icon(
      Icons.home_outlined,
      size: kSize,
    ),
    'selectedIcon': Icon(
      Icons.home,
      size: kSize,
      color: kColor,
    ),
  },
  {
    'label': 'Infos',
    'icon': Icon(
      Icons.info_outline,
      size: kSize,
    ),
    'selectedIcon': Icon(
      Icons.info,
      size: kSize,
      color: kColor,
    ),
  },
  {
    'label': 'Explorer',
    'icon': Icon(
      Icons.open_in_browser,
      size: kSize,
    ),
    'selectedIcon': Icon(
      Icons.open_in_browser,
      size: kSize,
      color: kColor,
    ),
  },
  {
    'label': 'Notification',
    'icon': Badge(
        isLabelVisible: false,
        label: null,
        child: Icon(
          Icons.notifications_none,
          size: kSize,
        )),
    'selectedIcon': Badge(
        isLabelVisible: false,
        label: null,
        child: Icon(
          Icons.notifications,
          size: kSize,
          color: kColor,
        )),
  },
];
