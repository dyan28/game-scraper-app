import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/components/loading_indicator.dart';
import 'package:apk_pul/components/smart_banner.dart';
import 'package:apk_pul/screens/all_games/all_games_controller.dart';
import 'package:apk_pul/screens/game_detail/game_detail_screen.dart';
import 'package:apk_pul/screens/games/components/store_game_tile.dart'
    show StoreGameTile;
import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                const crossAxisCount = 2;

                final firstRowCount = games.length >= crossAxisCount
                    ? crossAxisCount
                    : games.length;
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
                  child: CustomScrollView(
                    slivers: [
                      if (showAdsBanner.value)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: SmartBanner(),
                          ),
                        ),
                      // ===== GRID: HÀNG 1 =====
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.86,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => GestureDetector(
                              onTap: () {
                                push(
                                  context,
                                  GameDetailScreen(game: games[index]),
                                );
                              },
                              child: StoreGameTile(
                                title: games[index].title ?? '',
                                iconUrl: games[index].icon ?? '',
                                bannerUrl: games[index].headerImage ??
                                    games[index].screenshots?.first ??
                                    '',
                                rating: games[index].scoreText,
                              ),
                            ),
                            childCount: 6, // chỉ 4 item đầu
                          ),
                        ),
                      ),

                      // ===== HÀNG 2: QUẢNG CÁO FULL-WIDTH =====
                      if (showAdsBanner.value)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: SmartBanner(),
                          ),
                        ),

                      // ===== GRID: CÁC HÀNG SAU =====
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.86,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, idx) {
                              final game = games[firstRowCount + idx];
                              return Hero(
                                tag: 'game-banner-${game.appId}$idx',
                                child: GestureDetector(
                                  onTap: () {
                                    push(context, GameDetailScreen(game: game));
                                  },
                                  child: StoreGameTile(
                                    title: game.title ?? '',
                                    iconUrl: game.icon ?? '',
                                    bannerUrl: game.headerImage ??
                                        game.screenshots?.first ??
                                        '',
                                    rating: game.scoreText,
                                  ),
                                ),
                              );
                            },
                            childCount: (games.length - firstRowCount)
                                .clamp(0, games.length),
                          ),
                        ),
                      ),
                    ],
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
