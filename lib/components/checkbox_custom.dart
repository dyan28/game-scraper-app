import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tap_two_play/generated/assets.gen.dart';
import 'package:tap_two_play/utils/app_text_style.dart';

class CheckboxCustom extends StatelessWidget {
  const CheckboxCustom({
    super.key,
    this.title,
    this.onTap,
    this.isChecked = false,
    this.isEnabled = true,
  });

  final bool isChecked;
  final bool isEnabled;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Row(
        children: [
          SvgPicture.asset(
            isChecked ? Assets.svg.icChecked.path : Assets.svg.icUnChecked.path,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Text('$title', style: AppTextStyles.textW500S16),
        ],
      ),
    );
  }
}
