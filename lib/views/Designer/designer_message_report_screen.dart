import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../utils/components/Custom_dialog.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusedbutton.dart';

class DesignerMessageReportScreen extends StatefulWidget {
  const DesignerMessageReportScreen({super.key});

  @override
  State<DesignerMessageReportScreen> createState() =>
      _DesignerMessageReportScreenState();
}

class _DesignerMessageReportScreenState
    extends State<DesignerMessageReportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'R E P O R T',
                    style: oStyleBlack18400,
                  ),
                  SvgPicture.asset(
                    AppImages.line,
                    color: AppColors.text1,
                  ),
                ],
              ),
            ),
            10.ph,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Container(
                          height: 40.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                              color: AppColors.counterColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r),
                              )),
                          child: Center(
                            child: Text(
                              'Report',
                              style: tSStyleBlack14400.copyWith(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 260.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                          color: Color(0xFFDADADA),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Brooke',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  color: Color(0xFF71727A),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'No worries. Let me know if you need any help 😉',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF6E6E6E),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      30.ph,
                      Container(
                        height: 155.h,
                        decoration: BoxDecoration(
                          color: AppColors.counterColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Type Reason',
                                  hintStyle: tSStyleBlack14600.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      50.ph,
                      SizedBox(
                        width: 177.w,
                        height: 42.h,
                        child: reusedButton(
                          text: 'REPORT',
                          ontap: () {
                            showCustomDialog(context,
                                title: 'Sure you want to report?',
                                message: 'Are you sure you want to report this?');
                          },
                          color: AppColors.red,
                          icon: Icons.east,
                        ),
                      ),
                      10.ph,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
