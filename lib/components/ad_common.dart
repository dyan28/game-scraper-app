// lib/ads/ad_random.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Test IDs của Google (đổi sang ID thật khi release)
class AdIds {
  static const banner = kReleaseMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';
  static const interstitial = kReleaseMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/6300978111';
}

/// Chính sách chọn slot banner ngẫu nhiên
class AdSlotPolicy {
  /// Danh sách vị trí ỨNG VIÊN (theo index hiển thị) mà bạn cho phép chèn banner (vd: sau card 4, 10, 16…)
  final List<int> candidateSlots;

  /// Tối đa bao nhiêu banner sẽ chèn vào 1 màn
  final int maxBanners;

  /// Khoảng cách tối thiểu giữa 2 banner (đơn vị: số item hiển thị)
  final int minGap;

  /// Seed để random ổn định trong 1 phiên (cùng seed -> cùng kết quả)
  final int? seed;

  const AdSlotPolicy({
    required this.candidateSlots,
    this.maxBanners = 2,
    this.minGap = 4,
    this.seed,
  });
}

/// Chọn các slot banner từ danh sách ứng viên, đảm bảo minGap & không vượt tổng item
List<int> pickAdSlots({
  required int displayItemCount, // tổng item hiển thị (content + ads) ước lượng
  required AdSlotPolicy policy,
}) {
  final rng = Random(policy.seed ?? DateTime.now().millisecondsSinceEpoch);
  final candidates = policy.candidateSlots
      .where((i) => i >= 0 && i < displayItemCount)
      .toList()
    ..shuffle(rng);

  final chosen = <int>[];
  for (final c in candidates) {
    if (chosen.length >= policy.maxBanners) break;
    final ok = chosen.every((x) => (x - c).abs() >= policy.minGap);
    if (ok) chosen.add(c);
  }
  chosen.sort();
  return chosen;
}

/// Map từ index hiển thị -> index dữ liệu content (bỏ qua các slot quảng cáo)
int contentIndexForDisplay(int displayIndex, List<int> adSlotsDisplay) {
  // Đếm có bao nhiêu ad slot trước/vị trí này
  int adsBefore = adSlotsDisplay.where((s) => s <= displayIndex).length;
  return displayIndex - adsBefore;
}

/// Quản lý banner & interstitial đơn giản (không RemoteConfig)
class AdManager {
  BannerAd? _banner;
  InterstitialAd? _interstitial;
  DateTime? _lastInterstitial;

  void dispose() {
    _banner?.dispose();
    _interstitial?.dispose();
  }

  // -------- Banner --------
  Future<BannerAd?> loadBanner() async {
    _banner?.dispose();
    final ad = BannerAd(
      adUnitId: AdIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    );
    await ad.load();
    _banner = ad;
    return _banner;
  }

  BannerAd? get banner => _banner;

  // -------- Interstitial --------
  Future<void> preloadInterstitial() async {
    if (_interstitial != null) return;
    await InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  bool _cooldownOk(int cooldownSec) {
    if (_lastInterstitial == null) return true;
    return DateTime.now().difference(_lastInterstitial!).inSeconds >=
        cooldownSec;
  }

  /// Hiển thị interstitial với tỉ lệ ngẫu nhiên [chance] (0..1) và cooldown giây.
  Future<bool> maybeShowInterstitial({
    double chance = 0.2, // 20% cơ hội
    int cooldownSec = 60, // cách nhau ít nhất 60s
  }) async {
    if (!_cooldownOk(cooldownSec)) return false;
    if (Random().nextDouble() > chance) return false;

    final ad = _interstitial;
    if (ad == null) return false;

    final c = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        ad.dispose();
        _interstitial = null;
        _lastInterstitial = DateTime.now();
        await preloadInterstitial();
        c.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, err) async {
        ad.dispose();
        _interstitial = null;
        await preloadInterstitial();
        c.complete(false);
      },
    );
    ad.show();
    return c.future;
  }
}

/// Widget banner gọn
class AdBannerSlot extends StatefulWidget {
  const AdBannerSlot({super.key});
  @override
  State<AdBannerSlot> createState() => _AdBannerSlotState();
}

class _AdBannerSlotState extends State<AdBannerSlot> {
  final _manager = AdManager();
  BannerAd? _ad;

  @override
  void initState() {
    super.initState();
    _manager.loadBanner().then((ad) {
      if (!mounted) return;
      setState(() => _ad = ad);
    });
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad ?? _manager.banner;
    if (ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
