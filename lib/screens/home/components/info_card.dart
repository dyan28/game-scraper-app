import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tap_two_play/generated/assets.gen.dart';
import 'package:tap_two_play/models/user_device.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/app_text_style.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    this.userDevice,
    this.isSelected = false,
  });

  final UserDevice? userDevice;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.buttonSecondaryLightGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: isSelected ? AppColors.primary : AppColors.greyCACACA,
          )),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8,
            child: userDevice?.icon != null
                ? Image.asset(userDevice!.icon!)
                : SvgPicture.asset(
                    Assets.svg.icProfile.path,
                    height: 8,
                    width: 8,
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            userDevice?.name ?? 'Unknown Device',
            style: AppTextStyles.textW300S14.copyWith(),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
