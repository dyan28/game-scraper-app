import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tap_two_play/generated/assets.gen.dart';

class CommonAppbar extends PreferredSize {
  CommonAppbar({
    String? title,
    String? subtitle,
    Key? key,
    bool showBackButton = false,
    bool centerTitle = true,
    void Function()? onTapBack,
    Widget? leadingWidget,
    Widget? titleWidget,
    List<Widget>? actions,
    double? elevation,
    PreferredSizeWidget? bottom,
    Color? color,
    Color? titleColor,
    Color? backButtonColor,
  }) : super(
          key: key,
          child: AppBar(
            bottom: bottom,
            centerTitle: centerTitle,
            elevation: elevation ?? 0,
            actions: actions != null ? [...actions] : null,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: color ?? Colors.white,
            // TODO(Dyan): handle text style
            title: titleWidget ??
                Column(
                  children: [
                    Text(
                      title ?? '',
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                      ),
                  ],
                ),
            leading: showBackButton
                ? BackButtonCustom(
                    onTapBack: onTapBack,
                    color: backButtonColor,
                  )
                : leadingWidget ?? const SizedBox(),
          ),
          preferredSize: bottom != null
              ? const Size.fromHeight(80)
              : const Size.fromHeight(44),
        );
}

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({
    Key? key,
    this.onTapBack,
    this.color,
  }) : super(key: key);

  final void Function()? onTapBack;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBack ?? () => Navigator.pop(context),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(left: 8),

        // TODO(Dyan): handle icon back in appbar
        child: SvgPicture.asset(
          Assets.svg.icBackIos.path,
          height: 45,
          fit: BoxFit.contain,
          color: color,
        ),
      ),
    );
  }
}
