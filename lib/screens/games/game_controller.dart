import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tap_two_play/models/game.dart';
import 'package:tap_two_play/screens/games/game_state.dart';

part 'game_controller.g.dart';

@Riverpod(keepAlive: true)
class GameController extends _$GameController {
  @override
  GameState build() {
    Future.microtask(_fetchGames);
    return GameState();
  }

  Future<void> _fetchGames() async {
    try {
      state = state.copyWith(isLoading: true);

      var gamePage = <Game>[];

      final response = await http.get(
        Uri.parse(
            'https://script.google.com/macros/s/AKfycbwO9twmnqDVIaltcA-QoutEB8g09U2iAwMAPo6vzjYbt67egVwE4j5jS-Pj4EDlNRLO/exec?limit=20&sheet=app_games'),
      );
      if (response.statusCode == 200) {
        final games = json.decode(response.body);
        final onlineGames = games['data'];
        if (onlineGames is! List) {
          state = state.copyWith(isLoading: false);
          throw Exception('Failed to load Game');
        }
        final gamesOnline = onlineGames.map((e) => Game.fromJson(e)).toList();
        if (gamesOnline.length > 3) {
          gamePage = gamesOnline.sublist(0, 3);
        }
        state = state.copyWith(
          games: gamesOnline,
          gamePage: gamePage,
          isLoading: false,
        );
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e);
    }
  }
}
