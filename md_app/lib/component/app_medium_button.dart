import 'package:flutter/material.dart';
import 'package:md_app/component/app_text_widget.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';
import 'package:md_app/util/size_config.dart';

class AppMediumButton extends StatelessWidget {
  final String label;

  final Color? borderColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? imagePath;
  final String? imagePath2;

  final Color? textColor;

  const AppMediumButton({
    super.key,
    required this.label,
    this.borderColor,
    this.iconColor,
    this.backgroundColor,
    this.imagePath,
    this.textColor,
    this.imagePath2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 6,
      width: SizeConfig.widthMultiplier * 43.5,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(
              imagePath!,
              height: 24, // Set the size of the image
              width: 24,
              fit: BoxFit.contain,
            ),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          AppTextWidget(
            text: label,
            fontSize: AppTextSize.textSizeSmall,
            fontWeight: FontWeight.w400,
            color: textColor ?? AppColors.thirdText,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          if (imagePath2 != null)
            Image.asset(
              imagePath2!,
              // height: 24, // Set the size of the image
              // width: 24,
              fit: BoxFit.contain,
            ),
        ],
      ),
    );
  }
}
