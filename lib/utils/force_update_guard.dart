import 'package:apk_pul/utils/dialog.dart';
import 'package:apk_pul/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateGuard {
  static bool needForceUpdate({
    required String serverMinVersion,
    required String currentVersion,
  }) {
    return compareVersions(currentVersion, serverMinVersion) < 0;
  }

  static Future<void> ensureUpToDate(
    BuildContext context, {
    required String serverMinVersion,
    required String androidPackage,
    required String iosAppId,
    String? note,
  }) async {
    final info = await PackageInfo.fromPlatform();
    final current = info.version; // bỏ build number
    if (needForceUpdate(
        serverMinVersion: serverMinVersion, currentVersion: current)) {
      await Dialogs(context).showForceUpdateDialog(
        context,
        title: 'Update required',
        message: note ??
            'Your app version ($current) is too old. Please update to continue.',
        androidPackage: androidPackage,
      );
    }
  }
}
