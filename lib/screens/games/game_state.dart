import 'package:apk_pul/models/game.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';

@freezed
class GameState with _$GameState {
  factory GameState({
    @Default(false) bool isLoading,
    @Default([]) List<Game> games,
    @Default([]) List<Game> gamePage,
    @Default(0) int currentPlayerIndex,
    @Default(CategoryGame.GAME) CategoryGame category,
  }) = _GameState;
}
