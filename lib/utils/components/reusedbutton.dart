import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';

class reusedButton extends StatelessWidget {
  String text;
  final void Function()? ontap;
  Color color;
  IconData? icon;
  reusedButton({
    super.key,
    required this.text,
    required this.ontap,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 5,
        ),
      ),
      onPressed: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              text,
              style: oStyleBlack16400.copyWith(color: AppColors.white),
            ),
          ),
          Center(
            child: Icon(
              icon,
              size: 20.sp,
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}

class reusedButton2 extends StatelessWidget {
  String text;
  final void Function()? ontap;
  Color color;
  IconData? icon;
  reusedButton2({
    super.key,
    required this.text,
    required this.ontap,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),
      ),
      onPressed: ontap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              text,
              style: tSStyleBlack16400.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
