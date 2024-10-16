import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../controllers/product_detail_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';

class CustomerContactScreen extends StatefulWidget {
  const CustomerContactScreen({super.key});

  @override
  State<CustomerContactScreen> createState() => _CustomerContactScreenState();
}

class _CustomerContactScreenState extends State<CustomerContactScreen> {
  final ProductDetailController controller = Get.put(ProductDetailController());
  final List<String> imageList = [
    AppImages.splash1,
    AppImages.splash1,
    AppImages.splash1,
  ];
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;

  final List<Color> colorOptions = [Colors.black, Colors.orange, Colors.grey];
  final List<String> sizeOptions = ['S', 'M', 'L'];

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
                            color: controller.currentIndex.value == entry.key
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
                15.ph,
                Text(
                  'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products.',
                  style: tSStyleBlack12400.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                15.ph,
                Text(
                  '\$120',
                  style: tSStyleBlack20400.copyWith(
                    color: Color(0xFFDD8560),
                  ),
                ),
                15.ph,
                Row(
                  children: [
                    // Color Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Color",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: List.generate(colorOptions.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 8.0),
                                padding: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedColorIndex == index
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: colorOptions[index],
                                  radius: 10,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(width: 30),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Size",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: List.generate(sizeOptions.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSizeIndex = index;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                margin: EdgeInsets.only(right: 8.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 6.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedSizeIndex == index
                                        ? Colors.black
                                        : Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  color: selectedSizeIndex == index
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    sizeOptions[index],
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: selectedSizeIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                40.ph,
                SizedBox(
                  height: 58.h,
                  child: reusedButton(
                    text: 'CONTACT',
                    ontap: () {},
                    color: AppColors.secondary,
                    icon: Icons.east,
                  ),
                ),
                15.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
