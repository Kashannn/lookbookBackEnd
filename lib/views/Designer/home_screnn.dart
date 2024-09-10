import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/reusable_widget.dart';

class DesignerHomeScreen extends StatelessWidget {
  const DesignerHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 26.h),
          child: Column(
            children: [
              Center(
                child: Text(
                  'HOME',
                  style: tSStyleBlack20500,
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  AppImages.line,
                  color: AppColors.text1,
                ),
              ),
              20.ph,
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductCard2(
                              imagePath: AppImages.splash,
                              title: 'MOHAN',
                              subtitle:
                                  'We work with monitoring programmes to ensure....',
                              price: '\$120',
                              onTap: () {
                                Get.toNamed('productDetail', arguments: {
                                  'title': '21WN Reversible Ring',
                                  'price': '\$120',
                                });
                              },
                            ),
                            ProductCard2(
                              imagePath: AppImages.photographer,
                              title: 'MOHAN',
                              subtitle:
                                  'We work with monitoring programmes to ensure....',
                              price: '\$120',
                              onTap: () {
                                Get.toNamed('productDetail', arguments: {
                                  'title': '21WN Reversible Ring',
                                  'price': '\$120',
                                });
                              },
                            ),
                          ],
                        ),
                        10.ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductCard2(
                              imagePath: AppImages.noti,
                              title: 'MOHAN',
                              subtitle:
                                  'We work with monitoring programmes to ensure....',
                              price: '\$120',
                              onTap: () {
                                Get.toNamed('productDetail', arguments: {
                                  'title': '21WN Reversible Ring',
                                  'price': '\$120',
                                });
                              },
                            ),
                            ProductCard2(
                              imagePath: AppImages.splash1,
                              title: 'MOHAN',
                              subtitle:
                                  'We work with monitoring programmes to ensure....',
                              price: '\$120',
                              onTap: () {
                                Get.toNamed('productDetail', arguments: {
                                  'title': '21WN Reversible Ring',
                                  'price': '\$120',
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed('addProduct');
          },
          elevation: 8.0,
          backgroundColor: AppColors.secondary,
          shape: const CircleBorder(),
          child:  Icon(Icons.add, color: Colors.white,
              size: 30.sp
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
