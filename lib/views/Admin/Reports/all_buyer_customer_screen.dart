import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Reports/report_screen.dart';

import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/custom_search_bar.dart';
import 'Message_report_screen.dart';

class AllBuyerCustomerScreen extends StatefulWidget {
  const AllBuyerCustomerScreen({super.key});

  @override
  State<AllBuyerCustomerScreen> createState() => _AllBuyerCustomerScreenState();
}

class _AllBuyerCustomerScreenState extends State<AllBuyerCustomerScreen> {
  bool isDesignerSelected = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: 924.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                CustomAppBar(),
                SizedBox(
                  height: 72.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'REPORTS',
                        style: tSStyleBlack18400,
                      ),
                      SvgPicture.asset(
                        AppImages.line,
                        color: AppColors.text1,
                      ),
                    ],
                  ),
                ),
                10.ph,
                SizedBox(
                  height: 43.h,
                  width: 385.w,
                  child: CustomSearchBar(),
                ),
                20.ph,
                Container(
                  height: 40.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Designer option
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDesignerSelected = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: isDesignerSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: isDesignerSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Designer',
                            style: TextStyle(
                              color: isDesignerSelected
                                  ? Color(0xFFE27240)
                                  : Color(0xFF6E6E6E),
                              fontSize: 16.sp,
                              fontWeight: isDesignerSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      // Customer option
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDesignerSelected = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: !isDesignerSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: !isDesignerSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            'Customer',
                            style: TextStyle(
                              color: !isDesignerSelected
                                  ? Color(0xFFE27240)
                                  : Color(0xFF6E6E6E),
                              fontSize: 16.sp,
                              fontWeight: !isDesignerSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        10.ph,
                        SizedBox(
                          height: 78.h,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const MessageReportScreen());
                            },
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Jhone  Lane (Designer)',
                                                style:
                                                    iStyleBlack13700.copyWith(
                                                  color: AppColors.text3,
                                                ),
                                              ),
                                              Text(
                                                '+49 40 60774609',
                                                style:
                                                    iStyleBlack15400.copyWith(
                                                  color: AppColors.text2,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_outlined,
                                        size: 25.sp,
                                        color: Color(0xFFE47F46),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        30.ph,
                        SizedBox(
                          height: 78.h,
                          child: InkWell(
                            onTap: () {},
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.counterColor2.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                          10.pw,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Jhone  Lane (Designer)',
                                                style:
                                                    iStyleBlack13700.copyWith(
                                                  color: AppColors.text3,
                                                ),
                                              ),
                                              Text(
                                                '+49 40 60774609',
                                                style:
                                                    iStyleBlack15400.copyWith(
                                                  color: AppColors.text2,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                        width: 117.w,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showCustomDialog(context,
                                                title:
                                                    'Sure you want to Unblock?',
                                                message:
                                                    'Are you sure you want to unblock this?');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.red,
                                            foregroundColor: AppColors.white,
                                          ),
                                          child: Text('Unblock',
                                              style: tSStyleBlack14400.copyWith(
                                                  color: AppColors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        30.ph,
                        SizedBox(
                          height: 78.h,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => const ReportScreen());
                            },
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Kashan Ashraf (Customer)',
                                                style:
                                                    iStyleBlack13700.copyWith(
                                                  color: AppColors.text3,
                                                ),
                                              ),
                                              Text(
                                                '03054294420',
                                                style:
                                                    iStyleBlack15400.copyWith(
                                                  color: AppColors.text2,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_outlined,
                                        size: 25.sp,
                                        color: Color(0xFFE47F46),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
