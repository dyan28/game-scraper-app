import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const String studyCollection = 'STUDY-COLLECTION';
  static const String userSettings = 'USER-SETTINGS';
  static const String APP_GAME = 'apps_game';
  static const String APP_GAME_ONLINE = 'game_online';
  static const String APP_ADS = 'ads_management';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> snackBarKey =
      GlobalKey<ScaffoldMessengerState>();

  static Future<dynamic> pushNamed(
    String routeName, {
    dynamic argument,
  }) async {
    await navigatorKey.currentState
        ?.pushNamed<dynamic>(routeName, arguments: argument);
  }
}

final showAdsBanner = ValueNotifier<bool>(true);