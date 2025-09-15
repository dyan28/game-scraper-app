import 'package:apk_pul/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Center(
          child: SpinKitThreeBounce(
        color: AppColors.buttonPrimaryGreenDark,
        size: 25.0,
      )
      ),
    );
  }
}
