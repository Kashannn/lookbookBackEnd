import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Products/remove_product_screen.dart';

import '../../../Model/AddProductModel/add_product_model.dart';
import '../../../controllers/admin_product_controller.dart';
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
  final AdminProductController controller = Get.put(AdminProductController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          width: 430.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              30.ph,
              SizedBox(
                height: 43.h,
                width: 385.w,
                child: CustomSearchBar3(
                  searchController: controller.searchController,
                ),
              ),
              10.ph,
              Expanded(
                child: Obx(() {
                  if (controller.filteredEventMap.isEmpty) {
                    return Center(child: Text('No events found.'));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children:
                          controller.filteredEventMap.entries.map((entry) {
                        String event = entry.key;
                        List<AddProductModel> products = entry.value;
                        return Column(
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
                                    event.toUpperCase(),
                                    style: tSStyleBlack18400,
                                  ),
                                  SvgPicture.asset(
                                    AppImages.line,
                                    color: AppColors.text1,
                                  ),
                                ],
                              ),
                            ),
                            GridView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 5.h,
                                childAspectRatio: 0.60,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                AddProductModel product = products[index];
                                return ProductCard(
                                  imagePath: product.images?.first ??
                                      AppImages.photographer,
                                  title: product.dressTitle ?? 'No Title',
                                  subtitle: product.category?.join(', ') ??
                                      'No Category',
                                  price: '\$${product.price ?? '0'}',
                                  onTap: () {
                                    Get.to(RemoveProductScreen(),
                                        arguments: product);
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
