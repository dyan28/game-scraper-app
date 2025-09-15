import 'package:apk_pul/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class HighlightEnglishText extends StatelessWidget {
  const HighlightEnglishText({super.key, this.textData = ''});
  final String textData;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: buildTextSpan(),
    );
  }

  TextSpan buildTextSpan() {
    final List<TextSpan> spans = [];

    final RegExp regExp = RegExp(r'\((.*?)\)');

    int currentIndex = 0;
    for (RegExpMatch match in regExp.allMatches(textData)) {
      // Thêm phần văn bản trước chuỗi trong ngoặc
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: textData.substring(currentIndex, match.start),
            style: AppTextStyles.textW500S16.copyWith(
                color: const Color(
                    0xff333333), // Màu nổi bật cho chuỗi trong ngoặc
                fontSize: 18,
                height: 1.7),
          ),
        );
      }

      // Thêm chuỗi trong ngoặc với màu nổi bật
      // match.group(0) là toàn bộ chuỗi khớp, bao gồm cả dấu ngoặc đơn.
      spans.add(
        TextSpan(
          text: match.group(0), // Lấy toàn bộ chuỗi khớp (bao gồm cả dấu ngoặc)
          style: AppTextStyles.textW500S16.copyWith(
              color:
                  const Color(0xff007BFF), // Màu nổi bật cho chuỗi trong ngoặc
              fontSize: 18,
              height: 1.7),
        ),
      );
      currentIndex = match.end;
    }

    // Thêm phần văn bản còn lại sau chuỗi trong ngoặc cuối cùng
    if (currentIndex < textData.length) {
      spans.add(
        TextSpan(
          text: textData.substring(currentIndex),
          style: AppTextStyles.textW500S16.copyWith(
            color: const Color(0xff333333), // Màu nổi bật cho chuỗi trong ngoặc
            fontSize: 18,
            height: 1.7,
          ),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
