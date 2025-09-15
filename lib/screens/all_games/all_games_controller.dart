import 'package:apk_pul/api/network_resource_state/network_resource_state.dart';
import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/models/game.dart';
import 'package:apk_pul/screens/all_games/all_games_state.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'all_games_controller.g.dart';

@Riverpod(keepAlive: true)
class AllGamesController extends _$AllGamesController {
  @override
  AllGamesState build() {
    Future.microtask(_fetchGame);
    return AllGamesState();
  }

  Future<void> _fetchGame() async {
    final supabase = Supabase.instance.client;
    try {
      state = state.copyWith(games: const NetworkResourceState.loading());

      var q = supabase
          .from(Constants.APP_GAME) // ví dụ 'apps_game'
          .select();

      // 2) Chỉ thêm filter khi có genreId
      if (state.category != CategoryGame.GAME) {
        q = q.eq('genre_id', state.category.id);
      }
      final data = await q.range(0, 17);

      final games = data.map((e) => Game.fromJson(e)).toList();
      state = state.copyWith(games: NetworkResourceState(games));
    } catch (e) {
      state = state.copyWith(games: NetworkResourceState.error(e.toString()));
    }
  }

  String _escapeIlike(String s) =>
      s.replaceAll('\\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');

  Future<void> searchGameByName(String keyword) async {
    final sb = Supabase.instance.client;
    try {
      final kw = keyword.trim();
      if (kw.isEmpty) {
        // nếu ô tìm kiếm rỗng: trả về list mặc định
        return _fetchGame(); // hoặc gọi hàm list hiện tại của bạn
      }

      state = state.copyWith(games: const NetworkResourceState.loading());

      var q = sb
          .from(Constants.APP_GAME) // ví dụ: 'apps_game'
          .select();

      final esc = _escapeIlike(kw);

      // Tìm theo title (mở rộng: thêm developer/summary với .or)
      // q = q.ilike('title', '%$esc%');
      q = q.or([
        'title.ilike.%$esc%',

        // 'summary.ilike.%$esc%', // bật nếu bảng có cột summary
      ].join(','));

      // Sắp xếp & giới hạn
      final rows = await q
          .order('updated', ascending: false)
          .limit(30); // hoặc .range(0, 29)

      final games = rows.map((e) => Game.fromJson(e)).toList();

      state = state.copyWith(games: NetworkResourceState(games));
    } catch (e) {
      state = state.copyWith(games: NetworkResourceState.error(e.toString()));
    }
  }

  Future<void> onChangeCategory(CategoryGame category) async {
    state = state.copyWith(category: category);
    await _fetchGame();
  }
}
