import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    super.key,
    this.trimWords = 100,
    this.style,
    this.linkTextStyle,
    this.expandText = 'More',
    this.collapseText = 'Less',
  });

  final String text;
  final int trimWords;
  final TextStyle? style;
  final TextStyle? linkTextStyle;
  final String expandText;
  final String collapseText;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final words = widget.text.trim().split(RegExp(r'\s+'));
    final needsTrim = words.length > widget.trimWords;

    final visibleText = !_expanded && needsTrim
        ? '${words.take(widget.trimWords).join(' ')}… '
        : '${widget.text} ';

    final link = _expanded ? widget.collapseText : widget.expandText;

    return Text.rich(
      TextSpan(
        text: visibleText,
        style: widget.style,
        children: needsTrim
            ? [
                TextSpan(
                  text: link,
                  style: widget.linkTextStyle ??
                      TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => setState(() => _expanded = !_expanded),
                ),
              ]
            : const [],
      ),
    );
  }
}
