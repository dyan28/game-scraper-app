import 'package:apk_pul/models/online_game_res.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';


@freezed
class HomeState with _$HomeState {

  factory HomeState({
    @Default(true) isLoading,
    @Default(<OnlineGameRes>[]) List<OnlineGameRes> gamesOnline,
    @Default('') String error,
    @Default(false) bool isShowAdsBanner,
  }) = _HomeState;

  
}