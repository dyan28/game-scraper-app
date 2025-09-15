import 'package:apk_pul/models/online_game_res.dart';
import 'package:apk_pul/screens/game_web_view_page.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GameCard extends StatelessWidget with Utils {
  const GameCard({super.key, required this.game});
  final OnlineGameRes game;

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '—';
    return DateFormat('dd-MM-yyyy').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (game.iframe == null) {
          return;
        }
        push(
          context,
          GameWebViewPage(iframeHtml: game.iframe!),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // icon / poster
            SizedBox(
              height: screenHeight(context) * 0.14,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: game.thumb != null
                    ? CachedNetworkImage(
                        imageUrl: game.thumb!,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        placeholder: (c, _) =>
                            Container(color: const Color(0xFF1E1E1E)),
                        errorWidget: (c, _, __) => Container(
                          color: const Color(0xFF1E1E1E),
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported_rounded,
                              color: Colors.white38),
                        ),
                      )
                    : Container(
                        color: const Color(0xFF1E1E1E),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.white38,
                        ),
                      ),
              ),
            ),
            // text
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ).copyWith(top: 4),
              child: Text(
                game.title ?? '',
                maxLines: 1,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.defaultFont.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.contentColorGreen,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)
                  .copyWith(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.event, size: 14, color: Colors.white54),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(game.releaseDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.contentColorCyan,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ).copyWith(top: 4),
              child: Text(
                game.developer ?? '—',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
