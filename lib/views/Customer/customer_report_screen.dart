import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../utils/components/Custom_dialog.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';

class CustomerReportScreen extends StatefulWidget {
  const CustomerReportScreen({super.key});

  @override
  State<CustomerReportScreen> createState() => _CustomerReportScreenState();
}

class _CustomerReportScreenState extends State<CustomerReportScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                Center(
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
                Center(
                  child: ProductCard(
                    imagePath: AppImages.photographer,
                    title: '21WN Reversible Ring',
                    subtitle: 'Cardigan',
                    price: '\$120',
                    onTap: () {
                      Get.toNamed('CustomerProductDetailScreen', arguments: {
                        'title': '21WN Reversible Ring',
                        'price': '\$120',
                      });
                    },
                  ),
                ),
                25.ph,
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
                30.ph,
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
    );
  }
}
