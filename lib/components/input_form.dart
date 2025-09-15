import 'package:apk_pul/utils/app_text_style.dart';
import 'package:flutter/material.dart';

enum RequiredType {
  required,
  eitherRequired,
  none,
}

class FormInputField extends StatelessWidget {
  const FormInputField({
    super.key,
    this.label,
    this.labelStyle,
    required this.inputWidget,
    this.requiredType = RequiredType.none,
  });

  final String? label;
  final TextStyle? labelStyle;
  final Widget inputWidget;
  final RequiredType requiredType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildLabel(requiredType),
        const SizedBox(
          height: 8,
        ),
        inputWidget,
      ],
    );
  }

  Widget _buildLabel(RequiredType requiredType) {
    if (requiredType != RequiredType.none) {
      return Row(
        children: [
          Text(
            label ?? '',
            style: labelStyle ??
                AppTextStyles.textW400S16.copyWith(
                  fontSize: AppTextStyles.fontSize_14,
                ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      );
    }
    return Text(
      label ?? '',
      style: labelStyle ??
          AppTextStyles.textW400S16.copyWith(
            fontSize: AppTextStyles.fontSize_14,
          ),
    );
  }
}
