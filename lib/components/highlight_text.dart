import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  const HighlightText({
    super.key,
    required this.fullText,
    required this.highlightText,
    this.defaultStyle,
    this.highlightStyle,
  });
  final String fullText;
  final String highlightText;
  final TextStyle? defaultStyle;
  final TextStyle? highlightStyle;

  @override
  Widget build(BuildContext context) {
    if (highlightText.isEmpty || !fullText.contains(highlightText)) {
      return Text(fullText, style: defaultStyle);
    }

    final List<TextSpan> spans = [];
    int startIndex = 0;

    // Tìm kiếm và tách chuỗi để highlight
    fullText.splitMapJoin(
      highlightText,
      onMatch: (match) {
        spans.add(
          TextSpan(
            text: match[0],
            style: highlightStyle ??
                const TextStyle(
                  backgroundColor: Colors.yellow, // Màu highlight mặc định
                  fontWeight: FontWeight.bold,
                ),
          ),
        );
        return match[0]!;
      },
      onNonMatch: (nonMatch) {
        spans.add(
          TextSpan(
            text: nonMatch,
            style: defaultStyle ??
                Theme.of(context).textTheme.bodyLarge, // Style mặc định
          ),
        );
        return nonMatch;
      },
    );

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}
