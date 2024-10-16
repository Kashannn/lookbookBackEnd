import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Products/photographer_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Firebase/firebase_addproduct_services.dart';
import '../../../Firebase/firebase_customerEnd_services.dart';
import '../../../Model/AddProductModel/add_photographer_model.dart';
import '../../../Model/AddProductModel/add_product_model.dart';
import '../../../Model/user/user_model.dart';
import '../../../controllers/product_detail_controller.dart';

import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/build_list.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';
import 'package:carousel_slider/carousel_options.dart';

import 'package:shimmer/shimmer.dart';

import '../../../utils/components/reusedbutton.dart';
import '../Designers/Designer_details_screen.dart';

class RemoveProductScreen extends StatefulWidget {
  const RemoveProductScreen({super.key});

  @override
  State<RemoveProductScreen> createState() => _RemoveProductScreenState();
}

class _RemoveProductScreenState extends State<RemoveProductScreen> {
  final ProductDetailController controller = Get.put(ProductDetailController());
  final FirebaseAddProductServices firebaseAddProductServices =
      FirebaseAddProductServices();
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  late AddProductModel product;
  @override
  void initState() {
    super.initState();
    product = Get.arguments as AddProductModel;
  }

  @override
  Widget build(BuildContext context) {
    final AddProductModel product = Get.arguments as AddProductModel;
    final List<String> imageList = product.images ?? [AppImages.splash];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.w,
                  vertical: 15.0.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCarousel(imageList),
                    SizedBox(height: 10.h),
                    Obx(() {
                      return _buildDotIndicators(imageList);
                    }),
                    SizedBox(height: 10.h),
                    _buildProductDetails(product!),
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
                        _buildSizeSection(
                            'Sizes', product.sizes ?? ['No sizes available']),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    _buildDesignerSection(product, context),
                    SizedBox(height: 15.h),
                    _buildPhotographerSection(context, product),
                    SizedBox(height: 25.h),
                    Text(
                      'Minimum Order Quantity (${product.minimumOrderQuantity})',
                      style: tSStyleBlack16400,
                    ),
                    10.ph,
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: reusedButton(
                        text: 'REMOVE PRODUCT',
                        ontap: () {
                          showCustomDialogToBlock(context,
                              title: 'Sure you want to remove?',
                              message: 'Are you sure you want to remove this?',
                              onConfirm: () {
                            if (product.id != null) {
                              controller.deleteProduct(
                                  product.id!, product.userId!);
                            } else {
                              print('Product ID is null');
                            }
                          });
                        },
                        color: AppColors.red,
                        icon: Icons.delete,
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
            "${product.dressTitle} (${product.category![0]})".toUpperCase() ??
                'No title',
            style: tSStyleBlack16600),
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
            text: 'PHOTOGRAPHER NAME ( ${photographer.name} )' ??
                'PHOTOGRAPHER NAME',
            ontap: () {
              Get.to(PhotographerDetailScreen(photographer: photographer));
            },
          );
        }
      },
    );
  }

  Widget _buildDesignerSection(AddProductModel product, BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: firebaseAddProductServices.fetchDesigner(product.userId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null) {
          return BuildList(
            image: AppImages.photographer,
            text: 'DESIGNER NAME',
            ontap: () {
              Get.snackbar("Error", "No designer details found.");
            },
          );
        } else {
          UserModel designer = snapshot.data!;
          String? designerImageUrl = designer.imageUrl;

          if (designerImageUrl != null && designerImageUrl.isNotEmpty) {
            print('Photographer Image URL: $designerImageUrl');
          } else {
            print('No photographer image available.');
          }

          return BuildList(
            image: designerImageUrl ?? AppImages.photographer,
            text:
                'DESIGNER NAME ( ${designer.fullName} )' ?? 'PHOTOGRAPHER NAME',
            ontap: () {
              Get.to(
                DesignerDetailsScreen(designer: designer),
              );
            },
          );
        }
      },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: socialLinks.map((link) {
            final title = link['title'] ?? 'Unknown';
            final url = link['link'] ?? 'N/A';
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: tSStyleBlack16400),
                GestureDetector(
                  onTap: () {
                    _launchUrl(url);
                  },
                  child: Text(url,
                      style: tSStyleBlack16400.copyWith(
                          color: AppColors.secondary)),
                ),
                10.h.ph
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeSection(String title, List<String> sizes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: tSStyleBlack12400), // Title for the section (e.g., "Sizes")
        SizedBox(width: 10.w), // Spacing between title and sizes
        Wrap(
          spacing: 8.0.w, // Horizontal space between circles
          children: sizes.map((size) {
            return Container(
              width: 28.w, // Circle width
              height: 28.h, // Circle height
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Circle shape
                color: Colors.black, // Background color for size circle
              ),
              child: Center(
                child: Text(
                  size,
                  style: tSStyleBlack10400.copyWith(
                      color: Colors.white), // Text style
                ),
              ),
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
