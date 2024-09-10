import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              20.ph,
              Center(
                child: SizedBox(
                  height: 72.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'PRODUCT REPORT',
                        style: tSStyleBlack18400,
                      ),
                      SvgPicture.asset(
                        AppImages.line,
                        color: AppColors.text1,
                      ),
                    ],
                  ),
                ),
              ),
              10.ph,
              DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(10.r),
                dashPattern: const [5, 5],
                color: Colors.red,
                child: Container(
                  width: 430.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Color(0xFFDC0909).withOpacity(0.08),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      ProductCard(
                        imagePath: AppImages.photographer,
                        title: '21WN Reversible Ring',
                        subtitle: 'Cardigan',
                        price: '\$120',
                        onTap: () {
                          Get.toNamed('RemoveProductScreen', arguments: {
                            'title': '21WN Reversible Ring',
                            'price': '\$120',
                          });
                        },
                      ),
                      10.pw,
                    ],
                  ),
                ),
              ),
              20.ph,
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
              20.ph,
              SizedBox(
                height: 42.h,
                width: 190.w,
                child: ElevatedButton(
                  onPressed: () {
                    showCustomDialog(context,
                        title: 'Sure you want to remove?',
                        message: 'Are you sure you want to remove this?');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Remove Product',
                          style: tSStyleBlack12400.copyWith(
                              color: AppColors.white)),
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
      ),
    );
  }
}
