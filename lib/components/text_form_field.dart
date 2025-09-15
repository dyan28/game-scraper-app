import 'package:apk_pul/utils/app_colors.dart';
import 'package:apk_pul/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  const TextFormFieldCustom({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComplete,
    this.obscureText = false,
    this.hintText,
  });
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onEditingComplete;
  final bool obscureText;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.zero,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      style: AppTextStyles.defaultMedium.copyWith(
        color: AppColors.black1,
        fontWeight: FontWeight.w500,
        fontSize: AppTextStyles.fontSize_13,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greyCACACA,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greenC6F0B7,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        isDense: true,
        // use prefixIcon for showing always.
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        // prefixIconConstraints: const BoxConstraints(
        //     minWidth: Constants.dimens_00, minHeight: Constants.dimens_00),
      ),
      onEditingComplete: onEditingComplete,
      obscureText: obscureText,
    );
  }
}
