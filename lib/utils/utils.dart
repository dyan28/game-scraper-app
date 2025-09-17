import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:apk_pul/common/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

int compareVersions(String a, String b) {
  a = a.split('+').first;
  b = b.split('+').first;

  List<int> pa = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  List<int> pb = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  while (pa.length < 3) pa.add(0);
  while (pb.length < 3) pb.add(0);

  for (int i = 0; i < 3; i++) {
    if (pa[i] > pb[i]) return 1;
    if (pa[i] < pb[i]) return -1;
  }
  return 0;
}

class Util {
  Util._();
  static String convertPrice(var price) {
    var f = NumberFormat("#,###", "vi_VI");
    price = f.format(price);
    return price;
  }

  static bool _isHttpUrl(String s) {
    final u = Uri.tryParse(s);
    return u != null &&
        u.hasScheme &&
        (u.scheme == 'http' || u.scheme == 'https') &&
        u.host.isNotEmpty;
  }

  static bool isFromPlay(String url) {
    if (url.startsWith('https://play.google.com/') ||
        url.contains('play.google.com')) {
      return true;
    }
    return false;
  }

  static List<String> toUrlList(dynamic value) {
    if (value == null) return [];

    // Nếu Supabase đã là mảng (jsonb[]), trả về luôn
    if (value is List) {
      final cleaned = value
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty && _isHttpUrl(s));
      final seen = <String>{};
      return cleaned.where((s) => seen.add(s)).toList();
    }

    if (value is String) {
      final s = value.trim();

      // Nếu là JSON array dạng "[...]", thử parse JSON trước
      if (s.startsWith('[')) {
        try {
          final arr = jsonDecode(s);
          if (arr is List) return toUrlList(arr);
        } catch (_) {/* fall back split by comma */}
      }

      // Mặc định: tách theo dấu phẩy (có thể có khoảng trắng)
      final parts = s.split(RegExp(r'\s*,\s*'));
      final cleaned = parts
          .map((e) => e.trim())
          .where((x) => x.isNotEmpty && _isHttpUrl(x));
      final seen = <String>{};
      return cleaned.where((x) => seen.add(x)).toList();
    }

    return [];
  }

  static Future<void> openStore({required String androidPackage}) async {
    final uri = Uri.parse(
        'https://play.google.com/store/apps/details?id=$androidPackage');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: thử market:// (Android)
      if (Platform.isAndroid) {
        final market = Uri.parse('market://details?id=$androidPackage');
        if (await canLaunchUrl(market)) {
          await launchUrl(market, mode: LaunchMode.externalApplication);
          return;
        }
      }
      throw 'Can not open: $uri';
    }
  }

  static Future<void> openStoreUrl({required String url}) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback: thử market:// (Android)
      if (Platform.isAndroid) {
        final market = Uri.parse(url);
        if (await canLaunchUrl(market)) {
          await launchUrl(market, mode: LaunchMode.externalApplication);
          return;
        }
      }
      throw 'Can not open: $uri';
    }
  }

  static List<int> listYear() {
    int currentYear = DateTime.now().year;

    List<int> years = [];

    for (int i = currentYear - 15; i <= currentYear + 15; i++) {
      years.add(i);
    }
    return years;
  }

  static List<String> splitParagraphIntoSentencesWithPunctuation(
      String paragraph) {
    // This regular expression captures the sentence content AND the punctuation.
    // It looks for any characters (non-greedy) followed by a sentence-ending punctuation,
    // potentially with some whitespace, and then either another sentence or the end of the string.
    final RegExp sentenceSplitter = RegExp(r'[^.!?]+[.!?]+(?:\s+|\n|$)');

    List<String> sentences = [];
    int start = 0;

    while (start < paragraph.length) {
      RegExpMatch? match =
          sentenceSplitter.firstMatch(paragraph.substring(start));

      if (match != null) {
        // The matched string includes the sentence and its punctuation, plus any trailing whitespace.
        String sentence = match.group(0)!;
        sentences.add(
            sentence.trim()); // Trim to remove any excess whitespace at the end
        start += sentence.length;
      } else {
        // If no more full sentences are found, add any remaining text as a final "sentence".
        String remainingText = paragraph.substring(start).trim();
        if (remainingText.isNotEmpty) {
          sentences.add(remainingText);
        }
        break;
      }
    }

    return sentences;
  }

  static List<String> convertStringToWordList(String text) {
    // This regular expression captures words and ensures punctuation stays with them.
    // It looks for sequences of non-whitespace characters, optionally followed by
    // punctuation marks (like commas, periods, question marks, exclamation marks).
    final RegExp wordWithPunctuation = RegExp(r'\S+[.,!?]*');

    List<String> words = [];

    // Find all matches of the pattern in the input text
    Iterable<RegExpMatch> matches = wordWithPunctuation.allMatches(text);

    for (final match in matches) {
      // Add the matched word (which includes its punctuation) to the list
      words.add(match.group(0)!);
    }

    return words;
  }

  static Future<void> launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }
}

mixin Utils {
  static final navigatorState = Constants.navigatorKey.currentState;

  // Get size safe area for screen
  EdgeInsets get sizeSafeArea => MediaQueryData.fromView(ui.window).padding;

  // Check device has notch or not
  bool get hasNotch => sizeSafeArea.bottom > 0;
  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  void popWithoutContext([dynamic value]) {
    navigatorState?.pop(value);
  }

  Future<dynamic>? pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> push(
    BuildContext context,
    Widget route, {
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) async {
    if (Platform.isIOS) {
      return Navigator.of(context, rootNavigator: true).push<dynamic>(
        CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) => route,
          settings: settings,
        ),
      );
    }
    return navigatorState?.push<dynamic>(
      MaterialPageRoute<dynamic>(
        builder: (context) => route,
        fullscreenDialog: fullscreenDialog,
        settings: settings,
      ),
    );
  }

  Future<dynamic> pushName(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool fullscreenDialog = false,
  }) async {
    return Navigator.of(context, rootNavigator: true).pushNamed<dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic>? pushAndRemoveUntil(Widget routerName) {
    return navigatorState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => routerName), (route) => false);
  }

  Future<dynamic> pushReplacement(Widget routerName) {
    return navigatorState!.pushReplacement(
      MaterialPageRoute<dynamic>(builder: (context) => routerName),
    );
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    BuildContext context,
    String routerName,
  ) {
    return Navigator.pushNamedAndRemoveUntil(
        context, routerName, (route) => false);
  }

  void unFocusScope(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

enum CategoryGame {
  GAME,
  GAME_ACTION,
  GAME_BOARD,
  GAME_PUZZLE,
  SPORTS,
}

extension CategoryExtension on CategoryGame {
  String get name {
    switch (this) {
      case CategoryGame.GAME:
        return 'Game🔥';
      case CategoryGame.GAME_ACTION:
        return 'Action ⚔️';
      case CategoryGame.GAME_BOARD:
        return 'Board 🎲';
      case CategoryGame.GAME_PUZZLE:
        return 'Puzzle🧩';
      case CategoryGame.SPORTS:
        return 'Sports ⚽';
      default:
        return '';
    }
  }

  String get id {
    switch (this) {
      case CategoryGame.GAME:
        return '';
      case CategoryGame.GAME_ACTION:
        return 'GAME_ACTION';
      case CategoryGame.GAME_BOARD:
        return 'GAME_BOARD';
      case CategoryGame.GAME_PUZZLE:
        return 'GAME_PUZZLE';
      case CategoryGame.SPORTS:
        return 'SPORTS';
      default:
        return '';
    }
  }
}
