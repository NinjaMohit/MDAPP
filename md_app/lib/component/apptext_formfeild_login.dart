import 'package:flutter/material.dart';
import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';

class AppTextFormfeildLogin extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;

  const AppTextFormfeildLogin(
      {super.key,
      required this.controller,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.validator,
      this.obscureText = false,
      this.enabled = true,
      this.readOnly = false,
      this.suffixIcon,
      this.prefixIcon,
      this.onChanged,
      this.focusNode,
      this.onFieldSubmitted});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: TextFormField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        onChanged: onChanged,
        obscureText: obscureText,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
              vertical: 13, horizontal: 12), // <-- This reduces height

          filled: true,
          fillColor: AppColors.primary,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: AppTextSize.textSizeSmall,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryText,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.textfeildcolor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.textfeildcolor,
              width: 1,
            ),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
