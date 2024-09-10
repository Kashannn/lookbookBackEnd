import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';

import 'constant/app_textstyle.dart';

class textfield extends StatelessWidget {
  final bool toHide;
  final String text;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool isNumeric;
  final IconData? optionalIcon;
  const textfield({
    super.key,
    required this.text,
    required this.toHide,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.errorText,
    this.keyboardType,
    this.isNumeric = false,
    this.optionalIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isNumeric ? TextInputType.number : keyboardType,
      controller: controller,
      obscureText: toHide,
      focusNode: focusNode,
      textInputAction:
          nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
      onSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          color: AppColors.greylight,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(100.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(100.r),
        ),
        errorText: errorText,
        suffixIcon: optionalIcon != null
            ? Icon(optionalIcon, color: AppColors.greylight)
            : null,
      ),
      style: tSStyleBlack16400,
    );
  }
}

class CustomTextField extends StatelessWidget {
  final bool toHide;
  final String text;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool isNumeric;
  final String? optionalSvgIcon;
  final IconData? optionalIcon;
  final bool isCentered;

  const CustomTextField({
    super.key,
    required this.text,
    required this.toHide,
    this.controller,
    this.focusNode,
    this.nextFocusNode,
    this.errorText,
    this.keyboardType,
    this.isNumeric = false,
    this.optionalSvgIcon,
    this.optionalIcon,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: isNumeric ? TextInputType.number : keyboardType,
        controller: controller,
        obscureText: toHide,
        focusNode: focusNode,
        textInputAction:
            nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
        onSubmitted: (_) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        decoration: InputDecoration(
          hintText: text,
          hintStyle: const TextStyle(
            color: AppColors.greylight,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.greylight,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.greylight,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.greylight,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.greylight,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          errorText: errorText,
          suffixIcon: optionalSvgIcon != null
              ? Container(
                  padding: const EdgeInsets.all(15.0),
                  child: SvgPicture.asset(
                    optionalSvgIcon!,
                    color: AppColors.grey4,
                  ),
                )
              : (optionalIcon != null
                  ? Icon(optionalIcon, color: AppColors.grey4)
                  : null),
        ),
        style: mStyleBlack16400);
  }
}
