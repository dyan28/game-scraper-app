import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tap_two_play/models/game.dart';
import 'package:tap_two_play/screens/games/game_state.dart';

part 'game_controller.g.dart';

@Riverpod(keepAlive: true)
class GameController extends _$GameController {
  @override
  GameState build() {
    Future.microtask(_fetchGame);
    return GameState();
  }
  Future<void> _fetchGame() async {
    final supabase = Supabase.instance.client;
    try {
      state = state.copyWith(isLoading: true);
      final data = await supabase.from('app_game').select()
          .range(0, 12);
      final games = data.map((e) => Game.fromJson(e)).toList();
      state = state.copyWith(
          games: games, isLoading: false, gamePage: games.sublist(0, 3));
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print(e);
    }
  }
}
