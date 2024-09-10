import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';

class MessageReportScreen extends StatefulWidget {
  const MessageReportScreen({super.key});

  @override
  State<MessageReportScreen> createState() => _MessageReportScreenState();
}

class _MessageReportScreenState extends State<MessageReportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: 924.h,
        width: 430.w,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(),
              SizedBox(
                height: 72.h,
                width: 430.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'MESSAGE REPORT',
                      style: tSStyleBlack18400,
                    ),
                    SvgPicture.asset(
                      AppImages.line,
                      width: 150.w,
                      height: 15.h,
                      color: AppColors.text1,
                    ),
                  ],
                ),
              ),
              10.ph,
              SizedBox(
                height: 105.h,
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0.r,
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
                      ],
                    ),
                    10.pw,
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(25.r),
                      dashPattern: [6, 3],
                      color: Colors.red,
                      strokeWidth: 1.5,
                      child: Container(
                        width: 260.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            25.r,
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
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'View Profile',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFFE27240),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              30.ph,
              SizedBox(
                width: 381.w,
                height: 178.h,
                child: InkWell(
                  onTap: () {},
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FE),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40.0.r,
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
                              10.pw,
                              Text(
                                'Jhone  Lane (Designer)',
                                style: iStyleBlack13700.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                              10.pw,
                              Text(
                                'View Profile',
                                style: iStyleBlack13700.copyWith(
                                  color: Color(0xFFE47F46),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 64.h,
                                  width: 340.w,
                                  child: Text(
                                    'This behavior has not only affected the overall morale of the team but has also hindered our ability to work effectively and cohesively.',
                                    style: iStyleBlack14400.copyWith(
                                      color: AppColors.text3,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                )
                              ])
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              60.ph,
              SizedBox(
                height: 42.h,
                width: 162.w,
                child: ElevatedButton(
                  onPressed: () {
                    showCustomDialog(context,
                        title: 'Sure you want to block?',
                        message: 'Are you sure you want to block this?');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Block'),
                      Icon(
                        Icons.east,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
