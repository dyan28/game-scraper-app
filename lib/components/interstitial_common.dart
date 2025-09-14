import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Dùng:
/// final ads = InterstitialCommon(prodId: 'YOUR_PROD_INTERSTITIAL_ID');
/// await ads.preload();
/// await ads.maybeShow(cooldownSec: 60, chance: 0.3);

class InterstitialCommon {
  InterstitialCommon({
    required this.prodId,
    this.debugId = _googleTestInterstitial,
  });

  /// Ad Unit ID
  final String prodId; // ID thật khi release
  final String debugId; // ID test khi debug

  static const String _googleTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';

  String get _adUnitId => kReleaseMode ? prodId : debugId;

  InterstitialAd? _ad;
  bool _loading = false;
  int _retry = 0;
  DateTime? _lastShown;

  /// Gọi sớm (initState / mở màn) để tải trước
  Future<void> preload() async {
    if (_ad != null || _loading) return;
    _loading = true;

    await InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(
          // nonPersonalizedAds: true, // bật nếu cần test ở EEA chưa có consent
          ),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
          _retry = 0;
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _loading = false;
          // Retry backoff: 1s, 2s, 4s, 8s, 16s, max 30s
          final delay = Duration(
              seconds: [1 << _retry, 30].reduce((a, b) => a < b ? a : b));
          _retry = (_retry + 1).clamp(0, 5);
          Future.delayed(delay, preload);
        },
      ),
    );
  }

  /// Kiểm tra cooldown (mặc định 60s)
  bool _cooldownOk(int sec) {
    final last = _lastShown;
    return last == null || DateTime.now().difference(last).inSeconds >= sec;
  }

  /// Thử hiển thị nếu đủ điều kiện:
  /// - đã preload xong
  /// - qua cooldown
  /// - qua ngẫu nhiên 'chance' (0..1)
  Future<bool> maybeShow({int cooldownSec = 60, double chance = 1.0}) async {
    if (!_cooldownOk(cooldownSec)) return false;
    if (chance < 1.0 && Random().nextDouble() > chance) return false;

    final ad = _ad;
    if (ad == null) return false;

    final c = Completer<bool>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        _lastShown = DateTime.now();
        preload(); // tải cho lần sau
        c.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _ad = null;
        preload();
        c.complete(false);
      },
    );

    ad.show();
    return c.future;
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
