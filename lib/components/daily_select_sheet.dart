import 'package:apk_pul/components/common_button.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:flutter/material.dart';

Future<int?> dailySelectSheet(
  BuildContext context, {
  required int initialIndex,
}) async {
  var currentIndex = initialIndex;
  final result = await showTopModalSheet<int?>(
    context: context,
    height: 310,
    child: StatefulBuilder(builder: (context, setState) {
      return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(
          vertical: kBottomNavigationBarHeight + kTextTabBarHeight / 2,
          horizontal: 16,
        ).copyWith(bottom: 16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Words',
                  style: AppTextStyles.textW500S16,
                ),
                RichText(
                    text: TextSpan(
                  text: '$currentIndex',
                  style: AppTextStyles.defaultBoldAppBar.copyWith(
                    color: AppColors.primary,
                  ),
                  children: [
                    TextSpan(text: '  words', style: AppTextStyles.textW500S16),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 32),
            Slider(
              value: currentIndex.toDouble(),
              min: 4,
              max: 18,
              divisions: 14,
              onChanged: (double value) {
                setState(() {
                  currentIndex = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            CommonButton(
              label: 'Confirm',
              onTap: () {
                Navigator.pop(context, currentIndex);
              },
              height: 46,
              width: double.infinity,
              bgColor: AppColors.primary,
            ),
          ],
        ),
      );
    }),
  );
  return result;
}

Future<int?> dailyTimeSheet(
  BuildContext context, {
  int initialIndex = 30,
}) async {
  var currentIndex = initialIndex;
  final result = await showTopModalSheet<int?>(
    context: context,
    height: 310,
    child: StatefulBuilder(builder: (context, setState) {
      return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(
          vertical: kBottomNavigationBarHeight + kTextTabBarHeight / 2,
          horizontal: 16,
        ).copyWith(bottom: 16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Study Time',
                  style: AppTextStyles.textW500S16,
                ),
                RichText(
                    text: TextSpan(
                  text: '$currentIndex',
                  style: AppTextStyles.defaultBoldAppBar.copyWith(
                    color: AppColors.primary,
                  ),
                  children: [
                    TextSpan(
                      text: '  Minutes',
                      style: AppTextStyles.textW500S16,
                    ),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 32),
            Slider(
              value: currentIndex.toDouble(),
              min: 15,
              max: 180,
              onChanged: (double value) {
                setState(() {
                  currentIndex = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            CommonButton(
              label: 'Confirm',
              onTap: () {
                Navigator.pop(context, currentIndex);
              },
              height: 46,
              width: double.infinity,
              bgColor: AppColors.primary,
            ),
          ],
        ),
      );
    }),
  );
  return result;
}

Future<T?> showTopModalSheet<T>({
  required BuildContext context,
  required Widget child,
  double? height, // Chiều cao tùy chọn cho sheet
  Color barrierColor = Colors.black54, // Màu nền mờ
}) async {
  return await Navigator.push(
    context,
    _TopModalSheetRoute<T>(
      child: child,
      height: height,
      barrierColor: barrierColor,
    ),
  );
}

// Route tùy chỉnh cho TopModalSheet
class _TopModalSheetRoute<T> extends PopupRoute<T> {
  final Widget child;
  final double? height;
  @override
  final Color barrierColor;

  _TopModalSheetRoute({
    required this.child,
    this.height,
    this.barrierColor = Colors.black54,
  });

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Top Modal Sheet';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double sheetHeight = height ?? constraints.maxHeight * 0.4;

        return Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Stack(
              children: <Widget>[
                // Hiển thị nền mờ
                Positioned.fill(
                  child: FadeTransition(
                    opacity: animation,
                    child: Container(color: barrierColor),
                  ),
                ),
                // Sheet thực tế
                Align(
                  alignment: Alignment.topCenter,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1), // Bắt đầu từ trên cùng
                      end: Offset.zero, // Trượt về vị trí 0,0
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    )),
                    child: SizedBox(
                      width: double.infinity,
                      height: sheetHeight,
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
