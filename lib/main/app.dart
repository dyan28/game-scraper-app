import 'package:animations/animations.dart';
import 'package:apk_pul/api/api_client.dart';
import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/common/core/routes.dart';
import 'package:apk_pul/common/data/local_secure_storage.dart';
import 'package:apk_pul/env/env_state.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
late StateNotifierProvider<ApiClient, EnvState> envProvider;
Future<void> setupAndRunApp({required EnvState env}) async {
  WidgetsFlutterBinding.ensureInitialized();

  envProvider =
      StateNotifierProvider<ApiClient, EnvState>((ref) => ApiClient(env, ref));
  final token = await SecureStorage.getToken();
  runApp(ProviderScope(
    child: App(
      isLogged: token.isNotEmpty,
    ),
  ));
}

class App extends ConsumerWidget {
  const App({
    super.key,
    this.isLogged = false,
  });
  final bool isLogged;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // initialize flutter local notification
    // NotificationUtil.initialize(context);

    return MaterialApp(
      navigatorKey: Constants.navigatorKey,
      scaffoldMessengerKey: Constants.snackBarKey,
      themeMode: ThemeMode.system,
      theme: ThemeData(
          primarySwatch: Colors.green,
        scaffoldBackgroundColor: AppColors.backgroundLightGray,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          color: AppColors.backgroundLightGray, //<-- SEE HERE
        ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType
                  .scaled,
            ),
          })
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.dashboardScreen,
      navigatorObservers: [routeObserver],
      routes: Routes.routes,
      localizationsDelegates: const [],
      builder: (context, child) => GestureDetector(
        // dismiss keyboard when tap outside whole app
        onTap: () =>
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
        child: child,
      ),
    );
  }
}
