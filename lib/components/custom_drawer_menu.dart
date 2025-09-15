// custom_drawer_menu.dart
import 'dart:io' show Platform;

import 'package:apk_pul/generated/assets.gen.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawerMenu extends StatefulWidget {
  const CustomDrawerMenu({
    super.key,
    this.appName = 'ApkPul',
    this.packageId = 'com.gnof.apkpul',
    this.playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.example.tap2play',
    this.termsUrl = 'https://modlegen.com/terms-of-service/',
    this.appStoreUrl = 'https://apps.apple.com/app/id0000000000',
    this.dmcaUrl = 'https://modlegen.com/dmca/',
    this.privacyUrl = 'https://modlegen.com/privacy-policy/',
    this.feedbackEmail = 'support@yourdomain.com',
  });

  final String appName;
  final String packageId;
  final String playStoreUrl;
  final String appStoreUrl;
  final String dmcaUrl;
  final String privacyUrl;
  final String termsUrl;
  final String feedbackEmail;

  @override
  State<CustomDrawerMenu> createState() => _CustomDrawerMenuState();
}

class _CustomDrawerMenuState extends State<CustomDrawerMenu> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() => _version = info.version);
    } catch (_) {}
  }

  void _toast(String msg) {
    final ctx = context;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _toast('Không mở được liên kết');
    }
  }

  Future<void> _sendFeedback() async {
    final subject =
        Uri.encodeComponent('${widget.appName} Feedback ($_version)');
    final body = Uri.encodeComponent('Hello ${widget.appName},\n\n');
    final uri =
        Uri.parse('mailto:${widget.feedbackEmail}?subject=$subject&body=$body');
    if (!await launchUrl(uri)) _toast('Cannot open email app');
  }

  Future<void> _shareApp() async {
    final link = Platform.isIOS ? widget.appStoreUrl : widget.playStoreUrl;
    await Share.share('Try ${widget.appName} at $link');
  }

  Future<void> _checkUpdate() async {
    // Android: dùng In-App Update (chỉ chạy trên thiết bị thực)
    if (!kIsWeb && Platform.isAndroid) {
      try {
        final info = await InAppUpdate.checkForUpdate();
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          _toast('New version available, please update');
          await InAppUpdate.performImmediateUpdate().catchError((_) async {
            // nếu immediate fail, thử flexible
            await InAppUpdate.startFlexibleUpdate();
            await InAppUpdate.completeFlexibleUpdate();
          });
        } else {
          _toast('You are using the latest version');
        }
        return;
      } catch (_) {
        // fallthrough mở Play Store
      }
    }
    // iOS/Web/Android fallback: mở trang store
    final link = Platform.isIOS ? widget.appStoreUrl : widget.playStoreUrl;
    await _openUrl(link);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withOpacity(.12),
                    cs.secondary.withOpacity(.10)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withOpacity(.4)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: cs.primaryContainer,
                    child: Image.asset(
                      Assets.images.appIcon.path,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.appName,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface)),
                        Text('Version $_version',
                            style: TextStyle(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _tile(
              icon: Icons.feedback_rounded,
              text: 'Feedback',
              onTap: _sendFeedback,
            ),
            _tile(
              icon: Icons.gavel_rounded,
              text: 'DMCA',
              onTap: () => _openUrl(widget.dmcaUrl),
            ),
            _tile(
              icon: Icons.share_rounded,
              text: 'Share App',
              onTap: _shareApp,
            ),
            _tile(
              icon: Icons.system_update_alt_rounded,
              text: 'Check for update',
              onTap: _checkUpdate,
            ),
            _tile(
              icon: Icons.privacy_tip_rounded,
              text: 'Policy & Privacy',
              onTap: () => _openUrl(widget.privacyUrl),
            ),
             _tile(
              icon: Icons.article_rounded,
              text: 'Terms & Conditions',
              onTap: () => _openUrl(widget.privacyUrl),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('© ${DateTime.now().year} ${widget.appName}',
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreenForest),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        Navigator.of(context).maybePop();
        onTap();
      },
    );
  }
}
