import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Products/photographer_detail_screen.dart';

import '../../../controllers/product_detail_controller.dart';
import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/build_list.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';
import '../Designers/Designer_details_screen.dart';

class RemoveProductScreen extends StatefulWidget {
  const RemoveProductScreen({super.key});

  @override
  State<RemoveProductScreen> createState() => _RemoveProductScreenState();
}

class _RemoveProductScreenState extends State<RemoveProductScreen> {
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
            // Static CustomAppBar that doesn't scroll
            const CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
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
                      Obx(
                        () {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imageList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => controller.onDotTap(entry.key),
                                child: Container(
                                  width: 8.0.w,
                                  height: 8.0.h,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 4.0.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.currentIndex.value ==
                                            entry.key
                                        ? AppColors.black
                                        : AppColors.greylight,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
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
                      15.ph,
                      BuildList(
                        image: AppImages.profile,
                        text: 'DESIGNER NAME (JHONE)',
                        ontap: () {
                          Get.to(
                            () => const DesignerDetailsScreen(),
                          );
                        },
                      ),
                      15.ph,
                      BuildList(
                        image: AppImages.profile,
                        text: 'PHOTOGRAPHER NAME (LISA)',
                        ontap: () {
                          Get.to(
                            () => const PhotographerDetailScreen(),
                          );
                        },
                      ),
                      25.ph,
                      SizedBox(
                        height: 58.h,
                        width: 399.w,
                        child: ElevatedButton(
                          onPressed: () {
                            showCustomDialog(context,
                                title: 'Sure you want to remove?',
                                message:
                                    'Are you sure you want to remove this?');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: AppColors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('REMOVE',
                                  style: tSStyleBlack14400.copyWith(
                                      color: AppColors.white)),
                              SvgPicture.asset(
                                AppImages.deleteIcon,
                              )
                            ],
                          ),
                        ),
                      ),
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
