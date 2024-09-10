import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/custom_app_bar.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/views/designer/designer_profile_screen.dart';
import 'package:lookbook/views/designer/photographer_profile_screen.dart';

import '../../controllers/product_detail_controller.dart';
import '../../utils/components/build_list.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/reusable_widget.dart';
import '../Admin/Products/photographer_detail_screen.dart';
import '../Customer/Customer_contact_screen.dart';
import '../designer/addproduct_screen1.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({super.key});

  final ProductDetailController controller = Get.put(ProductDetailController());

  final List<String> imageList = [
    AppImages.splash,
    AppImages.splash1,
    AppImages.splash2,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0.w,
            vertical: 15.0.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBar(),
              20.ph,
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider.builder(
                      carouselController: controller.carouselSliderController,
                      itemCount: imageList.length,
                      itemBuilder: (context, index, realIndex) {
                        return Stack(
                          children: [
                            Image.asset(
                              imageList[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 400.h,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => FullScreenImageViewer(
                                        imagePath: imageList[index],
                                      ));
                                },
                                child: SvgPicture.asset(AppImages.extendIcon),
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: 400.h,
                        viewportFraction: 1.0,
                        autoPlay: false,
                        onPageChanged: (index, reason) {
                          controller.onPageChanged(index);
                        },
                      ),
                    ),
                    10.ph,
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => controller.onDotTap(entry.key),
                            child: Container(
                              width: 8.0.w,
                              height: 8.0.h,
                              margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    controller.currentIndex.value == entry.key
                                        ? AppColors.black
                                        : AppColors.greylight,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    10.ph,
                    Text(
                      'MOHAN',
                      style: tSStyleBlack16400,
                    ),
                    5.ph,
                    Text(
                      'Recycle Boucle Knit Cardigan Pink',
                      style: tSStyleBlack16400.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    20.ph,
                    BuildList(
                      image: AppImages.profile,
                      text: 'DESIGNER NAME (JHONE)',
                      ontap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              builder: (_, controller) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.r),
                                      topRight: Radius.circular(30.r),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 0.h),
                                  child: const DesignerProfileScreen(),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    15.ph,
                    BuildList(
                      image: AppImages.profile,
                      text: 'PHOTOGRAPHER NAME (LISA)',
                      ontap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.5,
                              builder: (_, controller) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.r),
                                      topRight: Radius.circular(30.r),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 0.h),
                                  child: const PhotographerProfileScreen(),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    20.ph,
                    Text(
                      'Minimum Order Quantity (150)',
                      style: tSStyleBlack16600,
                    ),
                    30.ph,
                    SizedBox(
                      height: 58.h,
                      child: reusedButton(
                        text: 'EDIT',
                        ontap: () {
                          Get.to(
                            () => AddproductScreen1(),
                          );
                        },
                        color: AppColors.secondary,
                        icon: Icons.edit,
                      ),
                    ),
                    10.ph,
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
