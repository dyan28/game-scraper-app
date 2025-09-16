import 'dart:developer';

import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/models/online_game_res.dart';
import 'package:apk_pul/screens/home/home_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  HomeState build() {
    Future.microtask(_fetchData);
    return HomeState();
  }

  Future<void> _fetchData() async {
    Future.wait([_fetchGame(), _fetchAdsBanner()]);
  }

  Future<void> _fetchGame() async {
    final supabase = Supabase.instance.client;
    try {
      state = state.copyWith(isLoading: true);
      final data = await supabase
          .from(Constants.APP_GAME_ONLINE)
          .select()
          .order(
            'release_date',
            ascending: false,
            nullsFirst: false,
          )
          .range(0, 12);
      final gamesOnline = data.map((e) => OnlineGameRes.fromMap(e)).toList();
      state = state.copyWith(gamesOnline: gamesOnline, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

  Future<void> _fetchAdsBanner() async {
    final supabase = Supabase.instance.client;
    try {
      state = state.copyWith(isLoading: true);
      final data = await supabase.from(Constants.APP_ADS).select().single();

      final gamesOnline = data['is_enabled'];
      showAdsBanner.value = gamesOnline as bool;
    } catch (e) {
      log('Errors: $e');
    }
  }
}
