import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SmartBanner extends StatefulWidget {
  const SmartBanner({super.key});
  @override
  State<SmartBanner> createState() => _SmartBannerState();
}

class _SmartBannerState extends State<SmartBanner> {
  BannerAd? _ad;
  int _retry = 0;

  static const _testBanner = 'ca-app-pub-3940256099942544/6300978111';
  String get _adUnitId =>
      kReleaseMode ? 'ca-app-pub-3940256099942544/6300978111' : _testBanner;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _ad?.dispose();
    final ad = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner, // hoặc thử adaptive khi cần
      request: const AdRequest(/* nonPersonalizedAds: true */),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          _ad = ad as BannerAd;
          _retry = 0;
        }),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          // Mã 3 = NO_FILL → retry với backoff (1s, 2s, 4s... max 30s)
          final delay = Duration(
              seconds: [1 << _retry, 30].reduce((a, b) => a < b ? a : b));
          _retry = (_retry + 1).clamp(0, 5);
          Future.delayed(delay, () {
            if (mounted) _load();
          });
        },
      ),
    );
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null) {
      // placeholder để UI không nhảy
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
