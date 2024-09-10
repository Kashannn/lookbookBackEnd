// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/build_links.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';

class DesignerProfileScreen extends StatelessWidget {
  const DesignerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 150.0.w,
                  child: const Divider(
                    thickness: 3,
                    color: AppColors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                    ),
                  )
                ],
              ),
              Center(
                child: Image.asset(
                  AppImages.profile,
                  width: MediaQuery.of(context).size.width,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              ),
              15.ph,
              Text(
                'JHONE',
                style: tSStyleBlack16400,
              ),
              15.ph,
              Text(
                'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products.',
                style: tSStyleBlack12400.copyWith(
                  color: AppColors.text1,
                ),
              ),
              15.ph,
              BuildLinks(
                image: AppImages.phone,
                ontap: () {},
                text: '+49 40 60774609',
              ),
              15.ph,
              BuildLinks(
                image: AppImages.mail,
                ontap: () {},
                text: 'info@eternal-vitality.de',
              ),
              15.ph,
              BuildLinks(
                image: AppImages.social,
                ontap: () {},
                text: '@Instagram/designer',
              ),
              20.ph,
            ],
          ),
        ),
      ),
    );
  }
}
