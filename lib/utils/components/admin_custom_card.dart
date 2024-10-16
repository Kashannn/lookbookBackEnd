import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'constant/app_textstyle.dart';

class CustomCard extends StatelessWidget {
  final String logoPath;
  final String title;
  final VoidCallback onPressed;

  const CustomCard({
    required this.logoPath,
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(5.r),
        child: Container(
          height: 104.h,
          width: 336.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(logoPath),
                Text(
                  title,
                  style: tSStyleBlack18400,
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.arrow_forward_outlined,
                    color: Color(0xFF9A9998),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
