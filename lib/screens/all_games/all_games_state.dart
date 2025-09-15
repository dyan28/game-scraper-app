import 'package:apk_pul/api/network_resource_state/network_resource_state.dart';
import 'package:apk_pul/models/game.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_games_state.freezed.dart';

@freezed
class AllGamesState with _$AllGamesState {
  factory AllGamesState({
    @Default(NetworkResourceState.loading())
    NetworkResourceState<List<Game>> games,
    @Default(CategoryGame.GAME) CategoryGame category,
  }) = _AllGamesState;
}
