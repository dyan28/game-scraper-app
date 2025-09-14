import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tap_two_play/api/network_resource_state/network_resource_state.dart';
import 'package:tap_two_play/models/game.dart';
import 'package:tap_two_play/utils/utils.dart';

part 'all_games_state.freezed.dart';

@freezed
class AllGamesState with _$AllGamesState {
  factory AllGamesState({
    @Default(NetworkResourceState.loading())
    NetworkResourceState<List<Game>> games,
    @Default(CategoryGame.GAME) CategoryGame category,
  }) = _AllGamesState;
}
