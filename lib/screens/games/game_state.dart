import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tap_two_play/models/game.dart';

part 'game_state.freezed.dart';

@freezed
class GameState with _$GameState {
  factory GameState({
    @Default(false) bool isLoading,
    @Default([]) List<Game> games,
    @Default(0) int currentPlayerIndex,
  }) = _GameState;
}
