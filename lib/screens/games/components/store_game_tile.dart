import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          color: AppColors.black393939,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 135,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: bannerUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.white),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFF1E1E1E),
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_rounded,
                            color: Colors.white38),
                      ),
                    ),
                  ),
                ),
                if (rating != null) ...[
                  Positioned(
                    bottom: 2,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: Color(0xFFFFD54F)),
                          const SizedBox(width: 4),
                          Text(
                            rating ?? '',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Colors.white24)),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              height: 24,
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
            ),
            const SizedBox(height: 8),

            // Banner
          ],
        ),
      ),
    );
  }
}
