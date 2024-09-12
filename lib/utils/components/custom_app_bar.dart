import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import 'constant/app_colors.dart';
import 'constant/app_textstyle.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.text1,
                  size: 20.sp,
                )),
            const Spacer(),
            Column(
              children: [
                Text(
                  'LOOK',
                  style: aStyleBlack20800,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.w),
                  child: Text(
                    'BOOK',
                    style: aStyleBlack20800,
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ],
    );
  }
}
