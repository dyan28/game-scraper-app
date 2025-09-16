import 'package:apk_pul/common/core/constants.dart';
import 'package:apk_pul/components/loading_indicator.dart';
import 'package:apk_pul/components/smart_banner.dart';
import 'package:apk_pul/screens/all_games/all_game.dart';
import 'package:apk_pul/screens/game_detail/game_detail_screen.dart';
import 'package:apk_pul/screens/games/components/store_game_tile.dart';
import 'package:apk_pul/screens/games/game_controller.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameDiscoveryPage extends ConsumerStatefulWidget {
  const GameDiscoveryPage({super.key});

  @override
  ConsumerState<GameDiscoveryPage> createState() => _GameDiscoveryPageState();
}

class _GameDiscoveryPageState extends ConsumerState<GameDiscoveryPage>
    with Utils {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final notifier = ref.read(gameControllerProvider.notifier);


  
    return Scaffold(
      body: state.isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                onTap: () {
                                  notifier.onChangePlayer(e);
                                },
                                child: _buildTab(e.name, state.category == e),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    // 🎮 Game carousel
                    SizedBox(
                      height: screenHeight(context) * 0.28,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.7),
                        children: List.generate(
                          state.gamePage.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                push(context,
                                    GameDetailScreen(game: state.games[index]));
                              },
                              child: GameCard(
                                title: state.gamePage[index].title ?? '',
                                rating: state.gamePage[index].scoreText ?? '',
                                imageUrl:
                                    state.gamePage[index].headerImage ?? '',
                                buttonText: "Download",
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (showAdsBanner.value) const Center(child: SmartBanner()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              push(context, const AllGame());
                            },
                            child: Text(
                              'More...',
                              style: AppTextStyles.defaultBoldAppBar.copyWith(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: screenWidth(context),
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
                          childAspectRatio: 0.87,
                        ),
                        itemCount: state.games.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              push(context,
                                  GameDetailScreen(game: state.games[index]));
                            },
                            child: Hero(
                              tag:
                                  'game-banner-${state.games[index].appId}$index',
                              child: StoreGameTile(
                                title: state.games[index].title ?? '',
                                iconUrl: state.games[index].icon ?? '',
                                bannerUrl: state.games[index].headerImage ??
                                    state.games[index].screenshots?.first ??
                                    '',
                                rating: state.games[index].scoreText,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

class GameCard extends StatelessWidget with Utils {
  final String title;
  final String rating;
  final String imageUrl;
  final String buttonText;

  const GameCard({
    super.key,
    required this.title,
    required this.rating,
    required this.imageUrl,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imageUrl,
                height: screenHeight(context) * 0.16,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(buttonText),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
