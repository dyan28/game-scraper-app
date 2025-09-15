import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CommonErrorIndicator extends StatelessWidget {
  const CommonErrorIndicator({
    Key? key,
    this.message,
    this.onTapRetry,
  }) : super(key: key);
  final String? message;
  final VoidCallback? onTapRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message ?? 'Errors',
            style: AppTextStyles.textW400S16,
          ),
          onTapRetry != null
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  onPressed: onTapRetry,
                  child: Text(
                    'Retry',
                    style: AppTextStyles.textW400S16.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
