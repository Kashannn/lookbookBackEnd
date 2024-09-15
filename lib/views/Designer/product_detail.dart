import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import '../../Firebase/firebase_addproduct_services.dart';
import '../../Model/AddProductModel/add_photographer_model.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import '../../controllers/product_detail_controller.dart';
import '../../utils/components/build_list.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';
import '../designer/addproduct_screen1.dart';
import '../designer/photographer_profile_screen.dart';

class ProductDetail extends StatelessWidget {
  final FirebaseAddProductServices firebaseAddProductServices =
      FirebaseAddProductServices();
  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    final AddProductModel product = Get.arguments;
    final List<String> imageList = product.images ?? [AppImages.splash];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: CustomAppBar(),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 15.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCarousel(imageList),
                      SizedBox(height: 10.h),
                      Obx(() {
                        return _buildDotIndicators(imageList);
                      }),
                      SizedBox(height: 10.h),
                      _buildProductDetails(product),
                      SizedBox(height: 10.h),
                      _buildListSection('Categories',
                          product.category ?? ['No categories available']),
                      SizedBox(height: 10.h),
                      _buildColorSection(
                          'Colors', product.colors ?? ['No colors available']),
                      SizedBox(height: 10.h),
                      _buildListSection(
                          'Sizes', product.sizes ?? ['No sizes available']),
                      SizedBox(height: 10.h),
                      _buildSocialLinks(product.socialLinks),
                      SizedBox(height: 15.h),
                      _buildPhotographerSection(context, product),
                      SizedBox(height: 20.h),
                      Text(
                        'Minimum Order Quantity: ${product.minimumOrderQuantity ?? '0'}',
                        style: tSStyleBlack16600,
                      ),
                      SizedBox(height: 30.h),
                      _buildEditButton(),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel(List<String> imageList) {
    return CarouselSlider.builder(
      carouselController: controller.carouselSliderController,
      itemCount: imageList.length,
      itemBuilder: (context, index, realIndex) {
        return Stack(
          children: [
            Image.network(
              imageList[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: 400.h,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 400.h,
                    color: Colors.white,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(AppImages.splash, fit: BoxFit.cover);
              },
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Get.to(
                      () => FullScreenImageViewer(imagePath: imageList[index]));
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
    );
  }

  // Dot Indicators
  Widget _buildDotIndicators(List<String> imageList) {
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
  }

  // Product Title and Description
  Widget _buildProductDetails(AddProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.dressTitle ?? 'No title', style: tSStyleBlack16400),
        SizedBox(height: 5.h),
        Text(product.productDescription ?? 'No description',
            style: tSStyleBlack16400.copyWith(color: AppColors.text1)),
      ],
    );
  }

  Widget _buildPhotographerSection(
      BuildContext context, AddProductModel product) {
    return FutureBuilder<AddPhotographerModel?>(
      future: firebaseAddProductServices.fetchPhotographer(product.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return BuildList(
            image: AppImages.photographer,
            text: 'PHOTOGRAPHER NAME',
            ontap: () {
              Get.snackbar("Error", "No photographer details found.");
            },
          );
        } else {
          AddPhotographerModel photographer = snapshot.data!;
          String? photographerImageUrl = photographer.image;

          if (photographerImageUrl != null && photographerImageUrl.isNotEmpty) {
            print('Photographer Image URL: $photographerImageUrl');
          } else {
            print('No photographer image available.');
          }

          return BuildList(
            image: photographerImageUrl ?? AppImages.photographer,
            text: photographer.name ?? 'PHOTOGRAPHER NAME',
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
                        child: PhotographerProfileScreen(
                            photographer: photographer),
                      );
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      height: 58.h,
      child: reusedButton(
        text: 'EDIT',
        ontap: () {
          Get.to(() => AddproductScreen1());
        },
        color: AppColors.secondary,
        icon: Icons.edit,
      ),
    );
  }

  Widget _buildSocialLinks(List<Map<String, String?>> socialLinks) {
    if (socialLinks.isEmpty) {
      return Text('No social links available', style: tSStyleBlack16400);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Social Links', style: tSStyleBlack16600),
        SizedBox(height: 5.h),
        Column(
          children: socialLinks.map((link) {
            final title = link['title'] ?? 'Unknown';
            final url = link['link'] ?? 'N/A';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: tSStyleBlack16400),
                Text(url,
                    style:
                        tSStyleBlack16400.copyWith(color: AppColors.secondary)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tSStyleBlack16600),
        SizedBox(height: 5.h),
        Wrap(
          spacing: 8.0.w,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSection(String title, List<String> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tSStyleBlack16600),
        SizedBox(height: 5.h),
        Wrap(
          spacing: 8.0.w,
          children: colors.map((colorCode) {
            try {
              final color =
                  Color(int.parse('0xFF${colorCode.replaceAll('#', '')}'));
              return Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              );
            } catch (e) {
              return Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Center(
                  child: Text('N/A', style: TextStyle(fontSize: 8.sp)),
                ),
              );
            }
          }).toList(),
        ),
      ],
    );
  }
}
