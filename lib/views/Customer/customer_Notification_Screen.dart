import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';

class CustomerNotificationScreen extends StatefulWidget {
  const CustomerNotificationScreen({super.key});

  @override
  State<CustomerNotificationScreen> createState() =>
      _CustomerNotificationScreenState();
}

class _CustomerNotificationScreenState
    extends State<CustomerNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 26.h),
          child: Column(
            children: [
              Center(
                child: Text(
                  'N O T I F I C A T I O N S',
                  style: oStyleBlack18400,
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  AppImages.line,
                  color: AppColors.text1,
                ),
              ),
              30.ph,
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.0.r,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.noti,
                        fit: BoxFit.cover,
                        width: 60.0.w,
                        height: 60.0.h,
                      ),
                    ),
                  ),
                  15.pw,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haley James',
                        style: iStyleBlack13700.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      5.ph,
                      Text(
                        'Stand up for what you believe in',
                        style: iStyleBlack15400.copyWith(
                          color: AppColors.text2,
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
