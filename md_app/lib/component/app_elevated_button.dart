import 'package:flutter/material.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final BorderRadiusGeometry borderRadius;

  // Constructor
  const AppElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.buttoncolor,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.textStyle = const TextStyle(),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
        textStyle: textStyle,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style: textStyle.copyWith(
            color: Colors.white,
            fontSize: AppTextSize.textSizeSmallm,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
