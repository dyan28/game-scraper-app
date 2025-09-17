import 'package:apk_pul/components/expandable_text.dart';
import 'package:apk_pul/components/smart_banner.dart';
import 'package:apk_pul/generated/assets.gen.dart';
import 'package:apk_pul/models/game.dart';
import 'package:apk_pul/screens/game_detail/game_meta_card.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class GameDetailScreen extends ConsumerWidget with Utils {
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
                      SizedBox(
                        width: screenWidth(context) * 0.7, // hoặc số px cụ thể
                        child: Text(
                          game.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 38,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (game.url != null && Util.isFromPlay(game.url!)) {
                    Util.openStoreUrl(url: game.url!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonPrimaryGreenDark,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Download',
                      style: AppTextStyles.defaultMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (Util.isFromPlay(game.url!))
                      SvgPicture.asset(
                        Assets.svg.icGoogle.path,
                        height: 20,
                        width: 20,
                      ),
                    if (!Util.isFromPlay(game.url!))
                      SvgPicture.asset(
                        Assets.svg.icApk.path,
                        height: 20,
                        width: 20,
                      ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SmartBanner(),
            ),
            GameMetaCard(
              score: double.tryParse(game.scoreText ?? '') ?? 0,
              installs: game.installs,
              developerName: game.developer ?? 'Unknown',
              developerUrl: Uri.parse(''),
              ratings: game.ratings ?? 0,
              released: DateTime.tryParse(game.updated ?? ''),
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
                    'Summary',
                    style: AppTextStyles.defaultBoldAppBar.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  ExpandableText(
                    game.summary ?? '',
                    trimWords: 50,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Description',
                        style: AppTextStyles.defaultBoldAppBar.copyWith(
                          fontSize: 24,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'More',
                            style: AppTextStyles.defaultMedium.copyWith(
                              color: AppColors.primaryBlueMedium,
                              fontSize: 14,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_right,
                              size: 16, color: AppColors.primaryBlueMedium),
                        ],
                      ),
                    ],
                  ),
                  Text(game.summary ?? ''),
                  ExpandableText(
                    game.description ?? '',
                    trimWords: 30,
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
