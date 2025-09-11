import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';


@freezed
class SessionState with _$SessionState {

  factory SessionState({
    @Default(false) isLogin,

  }) = _SessionState;

  
}