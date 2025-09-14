import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/components/loading_indicator.dart';
import 'package:tap_two_play/screens/all_games/all_games_controller.dart';
import 'package:tap_two_play/screens/game_detail/game_detail_screen.dart';
import 'package:tap_two_play/screens/games/components/store_game_tile.dart'
    show StoreGameTile;
import 'package:tap_two_play/screens/games/game_controller.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/app_text_style.dart';
import 'package:tap_two_play/utils/utils.dart';

class AllGame extends ConsumerStatefulWidget {
  const AllGame({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllGameState();
}

class _AllGameState extends ConsumerState<AllGame> with Utils {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(allGamesControllerProvider);
    final notifier = ref.read(allGamesControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        title: Text(
          'All Games',
          style: AppTextStyles.defaultBoldAppBar.copyWith(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onEditingComplete: () {
                    notifier.searchGameByName(_searchController.text);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search games...",
                    icon: Icon(Icons.search, color: Colors.black54),
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: CategoryGame.values
                    .map(
                      (e) => GestureDetector(
                        onTap: () async {
                          await notifier.onChangeCategory(e);
                        },
                        child: _buildTab(e.name, state.category == e),
                      ),
                    )
                    .toList(),
              ),
            ),
            state.games.maybeWhen(
              (listGame) {
                final games = listGame ?? [];
                if (games.isEmpty) {
                  return Expanded(
                    child: Center(
                        child: Text(
                      'No games found',
                      style: AppTextStyles.defaultFont.copyWith(fontSize: 18),
                    )),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: games.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          push(context, GameDetailScreen(game: games[index]));
                        },
                        child: Hero(
                          tag: 'game-banner-${games[index].appId}$index',
                          child: StoreGameTile(
                            title: games[index].title ?? '',
                            iconUrl: games[index].icon ?? '',
                            bannerUrl: games[index].headerImage ??
                                games[index].screenshots?.first ??
                                '',
                            rating: games[index].scoreText,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Expanded(
                child: Center(
                  child: LoadingIndicator(),
                ),
              ),
              error: (e) => Center(
                child: Text(e),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(right: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.buttonSecondaryLightGray,
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFF00E5FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isActive ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
