import 'package:apk_pul/generated/fonts.gen.dart';
import 'package:apk_pul/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const double fontSize_10 = 10;
  static const double fontSize_11 = 11;
  static const double fontSize_12 = 12;
  static const double fontSize_13 = 13;
  static const double fontSize_14 = 14;
  static const double fontSize_15 = 15;
  static const double fontSize_16 = 16;
  static const double fontSize_18 = 18;
  static const double fontSize_20 = 20;
  static const double fontSize_24 = 24;
  static const double fontSize_28 = 28;
  static const double fontSize_29 = 29;

  static TextStyle textW300S14 = const TextStyle(
    fontSize: fontSize_14,
    fontFamily: FontFamily.sFProDisplayLight,
  );
  static TextStyle textW400S16 = const TextStyle(
    fontSize: fontSize_16,
    color: AppColors.black1,
    fontFamily: FontFamily.sFProDisplayLight,
  );

  static TextStyle textW500S16 = const TextStyle(
    fontSize: fontSize_16,
    color: AppColors.black1,
    fontFamily: FontFamily.sFProDisplayMedium,
  );
  static TextStyle textW600S16 = const TextStyle(
    fontSize: fontSize_16,
    color: AppColors.black1,
    fontFamily: FontFamily.sFProDisplaySemiBold,
  );
  static TextStyle textW700S16 = const TextStyle(
    fontSize: fontSize_16,
    fontFamily: FontFamily.sFProDisplayBold,
    color: AppColors.black1,
  );
  static TextStyle defaultMedium = const TextStyle(
    fontSize: fontSize_16,
    color: AppColors.black1,
    fontWeight: FontWeight.w400,
  );

  static TextStyle defaultFont = const TextStyle(
    fontSize: fontSize_16,
    color: AppColors.black1,
    fontWeight: FontWeight.w400,
     fontFamily: FontFamily.sFProDisplayMedium,
  );

  static TextStyle defaultBoldAppBar = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: fontSize_20,
    fontFamily: FontFamily.sFProDisplayBold,
    color: AppColors.black1,
  );
}
