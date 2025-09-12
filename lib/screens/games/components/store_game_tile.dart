import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/app_text_style.dart';

class StoreGameTile extends StatelessWidget {
  const StoreGameTile({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.bannerUrl,
    this.rating,
    this.genre,
    this.onTap,
    this.onDownload,
    this.buttonText = 'Download',
  });

  final String title;
  final String iconUrl;
  final String bannerUrl;
  final String? rating;
  final String? genre;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 2),

        decoration: BoxDecoration(
          color: AppColors.black393939,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  // icon app
                  CachedNetworkImage(
                    imageUrl: iconUrl,
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
                  const SizedBox(width: 10),
                  // title + rating + genre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (rating != null) ...[
                              const Icon(Icons.star_rounded,
                                  size: 16, color: Color(0xFFFFD54F)),
                              const SizedBox(width: 4),
                              Text(
                                rating ?? '',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              const Text('•',
                                  style: TextStyle(color: Colors.white24)),
                              const SizedBox(width: 8),
                            ],
                            if (genre != null)
                              Text(genre!,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // nút tải xuống
                  TextButton(
                    onPressed: onDownload,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF2DBA74),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: const Size(0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: AppTextStyles.textW500S16.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Banner
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: Colors.white),
                  errorWidget: (_, __, ___) => Container(
                    color: const Color(0xFF1E1E1E),
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image_rounded,
                        color: Colors.white38),
                  ),
                ),
              ),
),
          ],
        ),
      ),
    );
  }
}
