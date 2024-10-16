import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';

import 'constant/app_textstyle.dart';

class textfield extends StatelessWidget {
  final bool toHide;
  final int? maxLines;
  final int? minLines;
  final String text;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool isNumeric;
  final ValueChanged<String>? onChanged;
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
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
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
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
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
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
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

class TextFieldWithEyeIcon extends StatefulWidget {
  final bool toHide;
  final String text;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool isNumeric;
  final IconData? optionalIcon;

  const TextFieldWithEyeIcon({
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
  _TextFieldWithEyeIconState createState() => _TextFieldWithEyeIconState();
}

class _TextFieldWithEyeIconState extends State<TextFieldWithEyeIcon> {
  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    isObscured = widget.toHide;
  }

  void togglePasswordVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType:
          widget.isNumeric ? TextInputType.number : widget.keyboardType,
      controller: widget.controller,
      obscureText: isObscured,
      focusNode: widget.focusNode,
      textInputAction: widget.nextFocusNode != null
          ? TextInputAction.next
          : TextInputAction.done,
      onSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      decoration: InputDecoration(
        hintText: widget.text,
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
        errorText: widget.errorText,
        suffixIcon: widget.toHide
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.black,
                ),
                onPressed: togglePasswordVisibility,
              )
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
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;

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
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.justify,
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
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(
          color: AppColors.greylight,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.greylight,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.r),
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
      style: mStyleBlack16400,
    );
  }
}
