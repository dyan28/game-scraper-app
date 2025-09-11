import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/api/api_client.dart';
import 'package:tap_two_play/common/core/constants.dart';
import 'package:tap_two_play/common/core/routes.dart';
import 'package:tap_two_play/common/data/local_secure_storage.dart';
import 'package:tap_two_play/env/env_state.dart';
import 'package:tap_two_play/utils/app_colors.dart';

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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.backgroundLightGray,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          color: AppColors.backgroundLightGray, //<-- SEE HERE
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.dashboardScreen,
      routes: Routes.routes,
      localizationsDelegates: const [],
      navigatorObservers: const [],
      builder: (context, child) => GestureDetector(
        // dismiss keyboard when tap outside whole app
        onTap: () =>
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
        child: child,
      ),
    );
  }
}
