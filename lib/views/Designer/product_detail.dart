import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Firebase/firebase_addproduct_services.dart';
import '../../Model/AddProductModel/add_photographer_model.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import '../../controllers/product_detail_controller.dart';
import '../../utils/components/build_list.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/constant/snackbar.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';
import '../designer/addproduct_screen1.dart';
import '../designer/photographer_profile_screen.dart';
import 'edit_product_screen.dart';

class ProductDetail extends StatelessWidget {
  final FirebaseAddProductServices firebaseAddProductServices =
      FirebaseAddProductServices();
  final ProductDetailController controller = Get.put(ProductDetailController());

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

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
              SizedBox(
                height: 72.h,
                width: 430.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'P R O D U C T  D E T A I L S',
                      style: tSStyleBlack18400,
                    ),
                    SvgPicture.asset(
                      AppImages.line,
                      color: AppColors.text1,
                    ),
                  ],
                ),
              ),
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
                      Text("\$${product.price.toString()}",
                          style: tSStyleBlack20400.copyWith(
                              color: AppColors.secondary)),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildColorSection('Colors',
                              product.colors ?? ['No colors available']),
                          SizedBox(width: 20.w),
                          _buildListSection(
                              'Sizes', product.sizes ?? ['No sizes available']),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        'Minimum Order Quantity (${product.minimumOrderQuantity ?? '0'})',
                        style: tSStyleBlack16400,
                      ),
                      SizedBox(height: 30.h),
                      _buildSocialLinks(product.socialLinks!),
                      SizedBox(height: 35.h),
                      _buildPhotographerSection(context, product),
                      SizedBox(height: 30.h),
                      _buildEditButton(product),
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

  Widget _buildProductDetails(AddProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            "${product.dressTitle} ( ${product.category![0]} )".toUpperCase() ??
                'No title',
            style: tSStyleBlack16600),
        SizedBox(height: 5.h),
        Text(
          product.productDescription ?? 'No description',
          style: tSStyleBlack16400.copyWith(color: AppColors.text1),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPhotographerSection(
      BuildContext context, AddProductModel product) {
    return FutureBuilder<AddPhotographerModel?>(
      future: firebaseAddProductServices.fetchPhotographer(product.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: AppColors.secondary,
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return BuildList(
            image: AppImages.photographer,
            text: 'PHOTOGRAPHER NAME',
            ontap: () {
              CustomSnackBars.instance.showFailureSnackbar(
                  title: "Error", message: "No photographer details found.");
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
            text: 'PHOTOGRAPHER NAME ( ${photographer.name} )' ??
                'PHOTOGRAPHER NAME',
            ontap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                    child:
                        PhotographerProfileScreen(photographer: photographer),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  SvgPicture _getSocialIcon(String url) {
    if (url.contains('facebook')) {
      return SvgPicture.asset(
        AppImages.facebook,
      );
    } else if (url.contains('instagram')) {
      return SvgPicture.asset(
        AppImages.social,
      );
    } else if (url.contains('whatsapp')) {
      return SvgPicture.asset(
        AppImages.whatsapp,
      );
    } else if (url.contains('snapchat')) {
      return SvgPicture.asset(
        AppImages.snapchat,
      );
    } else if (url.contains('tiktok')) {
      return SvgPicture.asset(
        AppImages.tiktok,
      );
    } else if (url.contains('youtube')) {
      return SvgPicture.asset(
        AppImages.youTube,
      );
    } else if (url.contains('linkedin')) {
      return SvgPicture.asset(
        AppImages.linkedIn,
      );
    } else if (url.contains('twitter')) {
      return SvgPicture.asset(
        AppImages.twitter,
      );
    } else if (url.contains('pinterest')) {
      return SvgPicture.asset(
        AppImages.pinterest,
      );
    } else {
      return SvgPicture.asset(
        'assets/icons/link.svg',
      );
    }
  }

  Widget _buildEditButton(AddProductModel product) {
    return SizedBox(
      height: 58.h,
      child: reusedButton(
        text: 'EDIT',
        ontap: () {
          Get.to(() => EditProductScreen(
                productId: product.id!,
                productModel: product,
              ));
          print(product.id);
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
        Text('Social Links', style: tSStyleBlack14600),
        SizedBox(height: 5.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: socialLinks.map((link) {
            final title = link['title'] ?? 'Unknown';
            final url = link['link'] ?? 'N/A';
            return GestureDetector(
              onTap: () {
                _launchUrl(url);
              },
              child: Row(
                children: [
                  _getSocialIcon(url),
                  10.pw,
                  Expanded(
                    child: Text(
                      url,
                      style: oStyleBlack14300.copyWith(
                        color: AppColors.text1,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  10.pw,
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.secondary,
                    size: 18,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: tSStyleBlack12400),
        SizedBox(width: 10.w),
        Wrap(
          spacing: 8.0.w,
          children: items.map((item) {
            return CircleAvatar(
              radius: 15.r,
              child: Text(
                item,
                style: tSStyleBlack10400.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.black,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSection(String title, List<String> colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: tSStyleBlack12400),
        SizedBox(width: 10.w),
        SizedBox(
          width: 150.w,
          child: Wrap(
            spacing: 8.0.w,
            runSpacing: 8.0.h,
            children: colors.map((colorCode) {
              try {
                final color =
                    Color(int.parse('0xFF${colorCode.replaceAll('#', '')}'));
                return Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                );
              } catch (e) {
                return Container(
                  width: 27.w,
                  height: 27.h,
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
        ),
      ],
    );
  }
}
