import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import '../../Firebase/firebase_addproduct_services.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/reusable_widget.dart';
import '../designer/product_detail.dart';

class DesignerHomeScreen extends StatelessWidget {
  DesignerHomeScreen({super.key});
  final FirebaseAddProductServices firebaseAddProductServices =
      FirebaseAddProductServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.w),
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
                child: FutureBuilder<List<AddProductModel>>(
                  future: firebaseAddProductServices.fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    } else {
                      final products = snapshot.data!;
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.w,
                          mainAxisSpacing: 5.h,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          String imageUrl = product.images?.isNotEmpty == true
                              ? product.images!.first
                              : AppImages.splash;
                          return ProductCard2(
                            imagePath: imageUrl,
                            title: product.dressTitle ?? 'No title',
                            subtitle:
                                product.productDescription ?? 'No description',
                            price: '\$${product.price ?? '0'}',
                            onTap: () {
                              Get.to(
                                ProductDetail(),
                                arguments: AddProductModel.fromMap(
                                  product.toMap(),
                                  product.id!,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
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
          child: Icon(Icons.add, color: Colors.white, size: 30.sp),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
