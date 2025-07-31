import 'package:fscore/core/constants/app/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> kDestinations = [
  {
    'label': 'Match',
    'icon': FaIcon(
      FontAwesomeIcons.house,
      size: kIconNavSize,
      color: kColor,
    ),
    'selectedIcon': FaIcon(
      FontAwesomeIcons.houseUser,
      size: kIconNavSize,
      color: kColor,
    ),
  },
  {
    'label': 'Infos',
    'icon': FaIcon(
      FontAwesomeIcons.info,
      size: kIconNavSize,
      color: kColor,
    ),
    'selectedIcon': FaIcon(
      FontAwesomeIcons.circleInfo,
      size: kIconNavSize,
      color: kColor,
    ),
  },
  {
    'label': 'Explorer',
    'icon': FaIcon(
      FontAwesomeIcons.arrowUp,
      size: kIconNavSize,
      color: kColor,
    ),
    'selectedIcon': FaIcon(
      FontAwesomeIcons.circleArrowUp,
      size: kIconNavSize,
      color: kColor,
    ),
  },
  {
    'label': 'Notification',
    'icon': Badge(
        isLabelVisible: false,
        label: null,
        child: FaIcon(
          FontAwesomeIcons.bell,
          size: kIconNavSize,
          color: kColor,
        )),
    'selectedIcon': Badge(
        isLabelVisible: false,
        label: null,
        child: FaIcon(
          FontAwesomeIcons.solidBell,
          size: kIconNavSize,
          color: kColor,
        )),
  },
];
