import 'package:apk_pul/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';


/// The Routes class contains static constants and a map of named routes to widget builders for
/// navigation in a Flutter app.
class Routes {
  static const dashboardScreen = '/dashboard_screen';
  static const loginScreen = '/login_screen';
  static const timeSetting = '/time_settings';
  static const appUsageDetailScreen = '/app_usage_detail_screen';
  static const usageTimerScreen = '/usage_timer_screen';
  static const registerDeviceScreen = '/register_device_screen';


  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => defaultRoute(),
    '/dashboard_screen': (context) => const DashBoardScreen(),

  };

  static defaultRoute() => const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Sorry for the unexpected problem !',
              ),
            ),
            SizedBox(height: 19),
          ],
        ),
      );
}
