import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tap_two_play/common/core/session/session_state.dart';
import 'package:tap_two_play/common/data/local_secure_storage.dart';

part 'session_controller.g.dart';

@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  SessionState build() {
    return SessionState();
  }

  // Future<void> saveSession({
  //   required String token,
  //   AppUser? appUser,
  // }) async {
  //   await SecureStorage.saveToken(token);
  //   await LocalStorage.saveAppUser(appUser);
  // }

  Future<void> clearSession() async {
    await SecureStorage.clearToken();

    state = state.copyWith(
      isLogin: false,
    );
  }
}
