import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/components/expandable_text.dart';
import 'package:tap_two_play/models/game.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/app_text_style.dart';

class GameDetailScreen extends ConsumerWidget {
  const GameDetailScreen({super.key, required this.game});
  final Game game;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 32).copyWith(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: game.headerImage ?? '',
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
              placeholder: (_, __) => Container(
                width: 36,
                height: 36,
                color: Colors.white12,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 36,
                height: 36,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported_rounded,
                  color: Colors.white54,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: game.icon ?? '',
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => Container(
                        width: 36,
                        height: 36,
                        color: Colors.white12,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 36,
                        height: 36,
                        color: Colors.white12,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.white54,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'v:${game.version ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.buttonPrimaryGreenDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        game.developer ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.grey999999,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonPrimaryGreenDark,
                    ),
                    child: Text(
                      'Download',
                      style: AppTextStyles.defaultMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 120,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundFaintGray,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Score: ',
                          style: AppTextStyles.defaultFont,
                          children: <TextSpan>[
                            TextSpan(
                              text: game.scoreText ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.contentColorBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Installs: ',
                          style: AppTextStyles.defaultFont,
                          children: <TextSpan>[
                            TextSpan(
                              text: game.installs ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.contentColorBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Developer: ',
                          style: AppTextStyles.defaultFont,
                          children: <TextSpan>[
                            TextSpan(
                              text: game.developer ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.contentColorBlue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Ratings: ',
                          style: AppTextStyles.defaultFont,
                          children: <TextSpan>[
                            TextSpan(
                              text: game.ratings.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.contentColorBlue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Released: ',
                          style: AppTextStyles.defaultFont,
                          children: <TextSpan>[
                            TextSpan(
                              text: game.released.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.contentColorBlue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                    imageUrl: game.screenshots?[index] ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.white12),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.white12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported_rounded,
                          color: Colors.white54, size: 18),
                    ),
                  );
                },
                itemCount: (game.screenshots ?? []).length,
                pagination: const SwiperPagination(
                  margin: EdgeInsets.only(bottom: 8),
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.white30,
                    activeColor: AppColors.buttonPrimaryGreenDark,
                    size: 6.0,
                    activeSize: 8.0,
                  ),
                ),
                control: const SwiperControl(
                  color: AppColors.buttonPrimaryGreenDark,
                  disableColor: Colors.white30,
                  size: 22.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: AppTextStyles.defaultBoldAppBar,
                  ),
                  ExpandableText(
                    game.description ?? '',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
