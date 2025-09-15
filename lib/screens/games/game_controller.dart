import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/models/game.dart';
import 'package:apk_pul/screens/games/game_state.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'game_controller.g.dart';

@Riverpod(keepAlive: true)
class GameController extends _$GameController {
  @override
  GameState build() {
    Future.microtask(_getData);
    return GameState();
  }

  void _getData() {
    Future.wait([_fetchGame(), _fetchTopGame()]);
  }

  Future<void> _fetchTopGame() async {
    final supabase = Supabase.instance.client;
    try {
      state = state.copyWith(isLoading: true);

      final rows = await supabase
          .from(Constants.APP_GAME)
          .select('*')
          .eq('in_top', true)
          .order('updated', ascending: false);

      final games = rows.map((e) => Game.fromJson(e)).toList();
      state = state.copyWith(
        gamePage: games,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

  Future<void> _fetchGame() async {
    final supabase = Supabase.instance.client;
    try {
      state = state.copyWith(isLoading: true);
      var q = supabase
          .from(Constants.APP_GAME) // ví dụ 'apps_game'
          .select();

      // 2) Chỉ thêm filter khi có genreId
      if (state.category != CategoryGame.GAME) {
        q = q.eq('genre_id', state.category.id);
      }
      final data = await q.limit(5);

      final games = data.map((e) => Game.fromJson(e)).toList();
      state = state.copyWith(games: games, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }

  Future<void> onChangePlayer(CategoryGame category) async {
    state = state.copyWith(category: category);
    await _fetchGame();
  }
}
