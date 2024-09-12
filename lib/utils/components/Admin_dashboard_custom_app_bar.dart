import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import 'constant/app_colors.dart';
import 'constant/app_images.dart';
import 'constant/app_textstyle.dart';

class AdminDashboardCustomAppBar extends StatelessWidget {
  const AdminDashboardCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: Column(
          children: [
            10.ph,
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed('AdminCustomMenu');
                  },
                  icon: SvgPicture.asset(
                    AppImages.menu,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
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
        ),
      ),
    );
  }
}
