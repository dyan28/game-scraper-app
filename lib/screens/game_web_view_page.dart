import 'dart:io';

import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class GameWebViewPage extends StatefulWidget {
  const GameWebViewPage({
    super.key,
    required this.iframeHtml, // chuỗi iframe từ API
    this.title = 'Tap2Play',
  });

  final String iframeHtml;
  final String title;

  @override
  State<GameWebViewPage> createState() => _GameWebViewPageState();
}

class _GameWebViewPageState extends State<GameWebViewPage> with Utils {
  late final WebViewController _c;

  @override
  void initState() {
    super.initState();
// Cho phép xoay tự do theo cảm biến khi đang ở trang game
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Ẩn system UI khi chơi cho đã (tuỳ chọn)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Đảm bảo platform implementation đã set (tránh lỗi assertion)
    if (Platform.isAndroid) {
      WebViewPlatform.instance ??= AndroidWebViewPlatform();
    } else if (Platform.isIOS || Platform.isMacOS) {
      WebViewPlatform.instance ??= WebKitWebViewPlatform();
    }

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (req) {
          final host = Uri.tryParse(req.url)?.host ?? '';
          final allow = host.endsWith('gamedistribution.com');
          return allow
              ? NavigationDecision.navigate
              : NavigationDecision.prevent;
        },
      ));

    // Android: cho autoplay media
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _c = controller;

    // nạp từ iframe HTML (CÁCH 2)
    loadFromIframeHtml(_c, widget.iframeHtml, title: widget.title);
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> loadFromIframeHtml(
    WebViewController controller,
    String iframeHtml, {
    String title = 'Tap2Play',
  }) async {
    final src = extractIframeSrc(iframeHtml);
    if (src == null) {
      throw Exception('Không tìm thấy src trong iframe HTML');
    }
    final doc = buildEmbedPage(src, title);
    // baseUrl nên dùng chính src để các URL tương đối (nếu có) hoạt động
    await controller.loadHtmlString(doc, baseUrl: src);
  }

  Future<void> _onBackPressed() async {
    if (await _c.canGoBack()) {
      await _c.goBack();
    } else {
      if (mounted) Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Không AppBar — dùng Stack để overlay nút back
      body: SafeArea(
        // SafeArea để tránh đụng tai thỏ/status bar
        child: Stack(
          children: [
            // WebView fill
            Positioned.fill(child: WebViewWidget(controller: _c)),
            // Back button nhỏ (overlay)
            Positioned(
              top: 8,
              left: 8,
              child: _BackCircleButton(onPressed: _onBackPressed),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 40,
                width: screenWidth(context),
                color: AppColors.black1,
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  String? extractIframeSrc(String iframeHtml) {
    final m = RegExp(r'<iframe[^>]*\ssrc="([^"]+)"', caseSensitive: false)
        .firstMatch(iframeHtml);
    return m?.group(1);
  }

  String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');

  String buildEmbedPage(String src, String title) {
    return '''
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no"/>
<title>${_esc(title)}</title>
<style>
  html,body,#root{height:100%;margin:0;background:#000;overflow:hidden}
  iframe{position:absolute;inset:0;width:100%;height:100%;border:0}
</style>
</head>
<body>
<div id="root">
  <iframe
    src="${_esc(src)}"
    allow="autoplay; fullscreen; gamepad; accelerometer; magnetometer; gyroscope; clipboard-read; clipboard-write"
    allowfullscreen
    referrerpolicy="no-referrer-when-downgrade"
    scrolling="no">
  </iframe>
</div>
</body>
</html>
''';
  }
}

/// Nút back tròn nhỏ dùng chung
class _BackCircleButton extends StatelessWidget {
  const _BackCircleButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.greenAccent,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
