import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/build_links.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';

class PhotographerDetailScreen extends StatefulWidget {
  const PhotographerDetailScreen({super.key});

  @override
  State<PhotographerDetailScreen> createState() =>
      _PhotographerDetailScreenState();
}

class _PhotographerDetailScreenState extends State<PhotographerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(),
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'JHONE LANE',
                    style: tSStyleBlack20400,
                  ),
                  SvgPicture.asset(
                    AppImages.line,
                    color: AppColors.text1,
                  ),
                ],
              ),
            ),
            10.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.cyan,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        AppImages.photographer,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  19.ph,
                  SizedBox(
                    height: 285.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'JHONE',
                          style: tSStyleBlack16400,
                        ),
                        Text(
                          'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products.',
                          style: tSStyleBlack12400.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                        10.ph,
                        Text(
                          'Phone Number',
                          style: tSStyleBlack16400,
                        ),
                        BuildLinks(
                          image: AppImages.phone,
                          ontap: () {},
                          text: '+49 40 60774609',
                        ),
                        Text(
                          'Email',
                          style: tSStyleBlack16400,
                        ),
                        BuildLinks(
                          image: AppImages.mail,
                          ontap: () {},
                          text: 'info@eternal-vitality.de',
                        ),
                        Text(
                          'Instagram',
                          style: tSStyleBlack16400,
                        ),
                        BuildLinks(
                          image: AppImages.social,
                          ontap: () {},
                          text: '@Instagram/photographer',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
