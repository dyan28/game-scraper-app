import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tap_two_play/models/online_game_res.dart';

part 'home_state.freezed.dart';


@freezed
class HomeState with _$HomeState {

  factory HomeState({
    @Default(true) isLoading,
    @Default(<OnlineGameRes>[]) List<OnlineGameRes> gamesOnline,
    @Default('') String error,
  }) = _HomeState;

  
}