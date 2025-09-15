import 'package:apk_pul/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GameMetaCard extends StatelessWidget {
  const GameMetaCard({
    super.key,
    this.score,
    this.installs,
    this.developerName,
    this.developerUrl,
    this.ratings,
    this.released,
    this.scoreUrl,
    this.installsUrl,
  });

  final double? score; // ví dụ 4.9
  final String? installs; // ví dụ "100,000,000+"
  final String? developerName; // ví dụ "Vita Studio."
  final Uri? developerUrl; // link tới trang dev
  final int? ratings; // ví dụ 3174027
  final DateTime? released; // ví dụ DateTime(2024,1,9)
  final Uri? scoreUrl; // link tới review trên store
  final Uri? installsUrl; // link tới trang app

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const bg = AppColors.backgroundFaintGray;
    final onBg = theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _StatPill(
            icon: Icons.star_rounded,
            label: 'Score',
            value: score != null
                ? score!.toStringAsFixed(score! % 1 == 0 ? 0 : 1)
                : '-',
            color: Colors.amber,
          ),
          _StatPill(
            icon: Icons.download_rounded,
            label: 'Installs',
            value: installs ?? '-',
            color: Colors.teal,
          ),
          _StatPill(
            icon: Icons.apartment_rounded,
            label: 'Developer',
            value: developerName ?? '-',
            color: Colors.blue,
            underline: developerUrl != null,
          ),
          _StatPill(
            icon: Icons.people_alt_rounded,
            label: 'Ratings',
            value: _compactInt(ratings),
            color: Colors.purple,
          ),
          _StatPill(
            icon: Icons.event_rounded,
            label: 'Updated',
            value: _formatDate(released),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  static Future<void> _open(Uri u) async {
    return;
  }

  static String _compactInt(int? n) {
    if (n == null) return '-';
    if (n >= 1000000000) {
      return '${(n / 1e9).toStringAsFixed(n % 1e9 == 0 ? 0 : 1)}B';
    }
    if (n >= 1000000) {
      return '${(n / 1e6).toStringAsFixed(n % 1e6 == 0 ? 0 : 1)}M';
    }
    if (n >= 1000) return '${(n / 1e3).toStringAsFixed(n % 1e3 == 0 ? 0 : 1)}K';
    return '$n';
  }

  static String _formatDate(DateTime? d) {
    if (d == null) return '-';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
    // cần locale chi tiết => dùng package 'intl'
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
    this.underline = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onTap != null ? color : theme.colorScheme.onSurface,
                decoration:
                    underline ? TextDecoration.underline : TextDecoration.none,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return pill;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: pill,
      ),
    );
  }
}
