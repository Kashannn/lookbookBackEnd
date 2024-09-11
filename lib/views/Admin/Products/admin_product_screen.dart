import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/custom_search_bar.dart';
import '../../../utils/components/reusable_widget.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({super.key});

  @override
  State<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends State<AdminProductScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(),
            20.ph,
            SizedBox(
              height: 43.h,
              width: 385.w,
              child: CustomSearchBar(),
            ),
            10.ph,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 72.h,
                            width: 430.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'UK FASHION SHOW',
                                  style: tSStyleBlack18400,
                                ),
                                SvgPicture.asset(
                                  AppImages.line,
                                  color: AppColors.text1,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductCard(
                                imagePath: AppImages.photographer,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                              ProductCard(
                                imagePath: AppImages.splash1,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductCard(
                                imagePath: AppImages.photographer,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                              ProductCard(
                                imagePath: AppImages.splash1,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
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
                    SizedBox(
                      height: 72.h,
                      width: 430.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'TEAR SHOW',
                            style: tSStyleBlack18400,
                          ),
                          SvgPicture.asset(
                            AppImages.line,
                            color: AppColors.text1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductCard(
                                imagePath: AppImages.splash,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                              ProductCard(
                                imagePath: AppImages.splash1,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductCard(
                                imagePath: AppImages.splash,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                              ProductCard(
                                imagePath: AppImages.splash1,
                                title: '21WN Reversible Ring',
                                subtitle: 'Cardigan',
                                price: '\$120',
                                onTap: () {
                                  Get.toNamed('RemoveProductScreen',
                                      arguments: {
                                        'title': '21WN Reversible Ring',
                                        'price': '\$120',
                                      });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
