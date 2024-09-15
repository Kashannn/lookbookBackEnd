import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../controllers/product_detail_controller.dart';
import '../../utils/components/Custom_dialog.dart';
import '../../utils/components/build_list.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';
import '../Designer/designer_profile_screen.dart';
import '../Designer/photographer_profile_screen.dart';
import 'Customer_contact_screen.dart';
import 'customer_report_screen.dart';

class CustomerProductDetailScreen extends StatefulWidget {
  const CustomerProductDetailScreen({super.key});

  @override
  State<CustomerProductDetailScreen> createState() =>
      _CustomerProductDetailScreenState();
}

class _CustomerProductDetailScreenState
    extends State<CustomerProductDetailScreen> {
  final ProductDetailController controller = Get.put(ProductDetailController());
  final List<String> imageList = [
    AppImages.splash1,
    AppImages.splash1,
    AppImages.splash1,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 15.0.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.ph,
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
                    10.ph,
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
                              minChildSize: 0.5,
                              builder: (_, controller) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.r),
                                      topRight: Radius.circular(30.r),
                                    ),
                                  ),
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
                              builder: (_, controller) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.r),
                                      topRight: Radius.circular(30.r),
                                    ),
                                  ),
                                  // child: const PhotographerProfileScreen(),
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
                      style: tSStyleBlack16400,
                    ),
                    10.ph,
                    SizedBox(
                      height: 50.h,
                      child: reusedButton(
                        text: 'CONTACT',
                        ontap: () {
                          Get.to(() => const CustomerContactScreen());
                        },
                        color: AppColors.secondary,
                        icon: Icons.east,
                      ),
                    ),
                    10.ph,
                    SizedBox(
                      width: 177.w,
                      height: 50.h,
                      child: reusedButton(
                        text: 'REPORT',
                        ontap: () {
                          Get.to(() => const CustomerReportScreen());
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
          ],
        ),
      ),
    );
  }
}
