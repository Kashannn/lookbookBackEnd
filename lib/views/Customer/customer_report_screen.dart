import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';

import '../../Model/AddProductModel/add_product_model.dart';
import '../../controllers/customer_report_controller.dart';
import '../../utils/components/Custom_dialog.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';

class CustomerReportScreen extends StatefulWidget {
  const CustomerReportScreen({super.key});
  @override
  State<CustomerReportScreen> createState() => _CustomerReportScreenState();
}

class _CustomerReportScreenState extends State<CustomerReportScreen> {
  late AddProductModel product;

  @override
  void initState() {
    super.initState();
    product = Get.arguments as AddProductModel;
  }

  @override
  Widget build(BuildContext context) {
    final CustomerReportController controller =
        Get.put(CustomerReportController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 72.h,
                  width: 430.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'R E P O R T',
                        style: oStyleBlack18400,
                      ),
                      SvgPicture.asset(
                        AppImages.line,
                        color: AppColors.text1,
                      ),
                    ],
                  ),
                ),
                10.ph,
                Center(
                  child: Container(
                    height: 40.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                        color: AppColors.counterColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        )),
                    child: Center(
                      child: Text(
                        'Report',
                        style: tSStyleBlack14400.copyWith(
                            color: AppColors.primaryColor),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ProductCard(
                    imagePath: product.images?.first ?? AppImages.splash,
                    title: product.dressTitle ?? 'No title available',
                    subtitle:
                        product.category?.join(', ') ?? 'No category available',
                    price: '\$${product.price}',
                    onTap: () {
                      // Navigate back to the product detail screen if needed
                      Get.toNamed('CustomerProductDetailScreen',
                          arguments: product);
                    },
                  ),
                ),
                25.ph,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.counterColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        maxLines: 5,
                        controller: controller.reasonController,
                        decoration: InputDecoration(
                          hintText: 'Type Reason',
                          hintStyle: tSStyleBlack14600.copyWith(
                            color: AppColors.primaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ],
                  ),
                ),
                30.ph,
                SizedBox(
                  width: 177.w,
                  height: 42.h,
                  child: reusedButton(
                    text: 'REPORT',
                    ontap: () {
                      showCustomDialogToBlock(context,
                          title: 'Sure you want to Report?',
                          message:
                              'Are you sure you want to report this product?',
                          onConfirm: () {
                        controller.reportProduct(context);
                      });
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
      ),
    );
  }
}
