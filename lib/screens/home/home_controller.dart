import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tap_two_play/models/online_game_res.dart';
import 'package:tap_two_play/screens/home/home_state.dart';

part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {
  @override
  HomeState build() {
    Future.microtask(_getGamesOnline);
    return HomeState();
  }

  Future<void> _getGamesOnline() async {
   
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await http.get(
        Uri.parse(
            'https://script.google.com/macros/s/AKfycbwO9twmnqDVIaltcA-QoutEB8g09U2iAwMAPo6vzjYbt67egVwE4j5jS-Pj4EDlNRLO/exec?limit=10&genreId=GAME_SIMULATION&sheet=game_online'),
      );
      if (response.statusCode == 200) {
        final games = json.decode(response.body);
        final onlineGames = games['data'];
        if (onlineGames is! List) {
          state = state.copyWith(isLoading: false);
          throw Exception('Failed to load album');
        }
        final gamesOnline =
            onlineGames.map((e) => OnlineGameRes.fromMap(e)).toList();
        state = state.copyWith(gamesOnline: gamesOnline, isLoading: false);
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print(e);
    }
  }
}
