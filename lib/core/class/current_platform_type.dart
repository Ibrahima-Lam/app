import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fscore/core/constants/app/platforme.dart';
import 'package:fscore/core/enums/platform_type.dart';

class CurrentPlatformType {
  final BuildContext context;

  CurrentPlatformType(this.context);

  static PlatformType get current {
    if (kIsWeb) {
      return PlatformType.web;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return PlatformType.mobile;
    } else {
      return PlatformType.desktop;
    }
  }

  bool isMobile() {
    return current == PlatformType.mobile;
  }

  bool isWeb() {
    return current == PlatformType.web;
  }

  bool isDesktop() {
    return current == PlatformType.desktop;
  }

  bool isTablet() {
    return MediaQuery.of(context).size.width < kMaxWidth && !isMobile();
  }

  bool isSmallScreen() {
    return MediaQuery.of(context).size.width < kMaxWidth;
  }

  bool isLargeScreen() {
    return MediaQuery.of(context).size.width >= kMaxWidth;
  }

  bool isLandscape() {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  bool isPortrait() {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  bool isNarrowScreen() {
    return MediaQuery.of(context).size.width < 480.0;
  }

  bool isWideScreen() {
    return MediaQuery.of(context).size.width >= 480.0;
  }

  bool isVeryWideScreen() {
    return MediaQuery.of(context).size.width >= 1200.0;
  }

  bool isExtraWideScreen() {
    return MediaQuery.of(context).size.width >= 1600.0;
  }

  bool isUltraWideScreen() {
    return MediaQuery.of(context).size.width >= 2000.0;
  }

  bool isExtraSmallScreen() {
    return MediaQuery.of(context).size.width < 320.0;
  }

  bool isSmallTablet() {
    return MediaQuery.of(context).size.width < 600.0 && !isMobile();
  }

  bool isLargeTablet() {
    return MediaQuery.of(context).size.width >= 600.0 && !isMobile();
  }

  bool isExtraLargeScreen() {
    return MediaQuery.of(context).size.width >= 1600.0;
  }

  bool isUltraLargeScreen() {
    return MediaQuery.of(context).size.width >= 2400.0;
  }

  bool isWebMobile() {
    return kIsWeb && MediaQuery.of(context).size.width < 600.0;
  }

  bool isWebDesktop() {
    return kIsWeb && MediaQuery.of(context).size.width >= 600.0;
  }

  bool isWebTablet() {
    return kIsWeb &&
        MediaQuery.of(context).size.width >= 600.0 &&
        MediaQuery.of(context).size.width < 1200.0;
  }

  bool isWebLargeTablet() {
    return kIsWeb &&
        MediaQuery.of(context).size.width >= 1200.0 &&
        MediaQuery.of(context).size.width < 1600.0;
  }

  bool isDesktopMobile() {
    return !kIsWeb &&
        (Platform.isAndroid || Platform.isIOS) &&
        MediaQuery.of(context).size.width < 600.0;
  }

  bool isSmallDesktop() {
    return !kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS) &&
        MediaQuery.of(context).size.width < 800.0;
  }
}
