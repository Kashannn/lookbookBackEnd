import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/AddProductModel/add_product_model.dart';
import 'package:lookbook/Model/AddProductModel/product_reported_model.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/controllers/all_buyer_customer_report_controller.dart';
import 'package:lookbook/controllers/product_detail_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Products/remove_product_screen.dart';
import 'package:lookbook/views/Admin/Reports/reported_profile_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Firebase/firebase_customerEnd_services.dart';
import '../../../controllers/message_report_controller.dart';
import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';

class ReportScreen extends StatefulWidget {
  final ProductReportedModel productReportedModel;

  const ReportScreen({
    super.key,
    required this.productReportedModel,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
  }

  final MessageReportController _controller =
      Get.put(MessageReportController());
  final AllBuyerCustomerReportController productController =
      Get.put(AllBuyerCustomerReportController());

  @override
  void initState() {
    super.initState();
    _controller.fetchReportedUser(widget.productReportedModel.reportedDesigner);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.productReportedModel.reportedBy;
    final ProductDetailController controller =
        Get.put(ProductDetailController());

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(),
                20.ph,
                Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'PRODUCT REPORT',
                          style: tSStyleBlack18400,
                        ),
                        SvgPicture.asset(
                          AppImages.line,
                          color: AppColors.text1,
                        ),
                      ],
                    ),
                  ),
                ),
                10.ph,
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(10.r),
                  dashPattern: const [5, 5],
                  color: Colors.red,
                  child: Container(
                    width: 430.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Color(0xFFDC0909).withOpacity(0.08),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder<UserModel?>(
                          future: FirebaseCustomerEndServices().fetchUser(
                              widget.productReportedModel.reportedDesigner),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData) {
                              return Text('No designer found.');
                            }

                            UserModel user = snapshot.data!;
                            return Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25.0.r,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: user.imageUrl != null &&
                                              user.imageUrl!.isNotEmpty
                                          ? Stack(
                                              children: [
                                                // Shimmer effect while the image is loading
                                                Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    height: 60.h,
                                                    width: 60.0.w,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.secondary
                                                          .withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                // Display Network Image
                                                Positioned.fill(
                                                  child: Image.network(
                                                    user.imageUrl!,
                                                    fit: BoxFit.cover,
                                                    height: 60.h,
                                                    width: 60.0.w,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          height: 60.h,
                                                          width: 60.0.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .secondary
                                                                .withOpacity(
                                                                    0.5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Container(
                                                        height: 60.h,
                                                        width: 60.0.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(0.5),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            getInitials(
                                                                user.fullName ??
                                                                    ''),
                                                            style:
                                                                tSStyleBlack18500
                                                                    .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: 60.h,
                                              width: 60.0.w,
                                              decoration: BoxDecoration(
                                                color: AppColors.secondary
                                                    .withOpacity(0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  getInitials(
                                                      user.fullName ?? ''),
                                                  style: tSStyleBlack18500
                                                      .copyWith(
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  12.pw,
                                  Text(
                                    user.fullName ?? '',
                                    style: iStyleBlack13700.copyWith(
                                      color: AppColors.text3,
                                    ),
                                  ),
                                  10.pw,
                                  GestureDetector(
                                    onTap: () {
                                      if (user.userId != null) {
                                        Get.to(() => ReportProfileScreen(
                                            userId: user!.userId!));
                                      } else {
                                        Get.snackbar(
                                            "Error", "User ID is null.",
                                            snackPosition: SnackPosition.TOP);
                                      }
                                    },
                                    child: Text(
                                      'View Profile',
                                      style: iStyleBlack13700.copyWith(
                                        color: Color(0xFFE47F46),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        FutureBuilder<AddProductModel?>(
                          future: productController.fetchProduct(
                              widget.productReportedModel.productId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // Show loading indicator
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData) {
                              return Text('No product found.');
                            }

                            AddProductModel product = snapshot.data!;
                            return ProductCard(
                              imagePath: product.images![0],
                              title: product.dressTitle!,
                              subtitle: product.productDescription!,
                              price: '\$${product.price!}',
                              onTap: () {
                                Get.to(RemoveProductScreen(),
                                    arguments: product);
                              },
                            );
                          },
                        ),
                        10.pw,
                      ],
                    ),
                  ),
                ),
                20.ph,
                SizedBox(
                  // width: 381.w,
                  child: InkWell(
                    onTap: () {},
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FE),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder<UserModel?>(
                              future: FirebaseCustomerEndServices().fetchUser(
                                  widget.productReportedModel.reportedBy),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Show loading indicator
                                }
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (!snapshot.hasData) {
                                  return Text('No user found.');
                                }

                                UserModel user = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 25.0.r,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: Stack(
                                            children: [
                                              // Shimmer effect placeholder
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: 60.0.w,
                                                  height: 60.0.h,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.secondary
                                                        .withOpacity(0.5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              // Display Network Image
                                              Image.network(
                                                user.imageUrl!,
                                                fit: BoxFit.cover,
                                                width: 60.0.w,
                                                height: 60.0.h,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    child: Container(
                                                      width: 60.0.w,
                                                      height: 60.0.h,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .secondary
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    width: 60.0.w,
                                                    height: 60.0.h,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.secondary
                                                          .withOpacity(0.5),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        getInitials(
                                                            user.fullName ??
                                                                ''),
                                                        style: tSStyleBlack18500
                                                            .copyWith(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      10.pw,
                                      Text(
                                        user.fullName!,
                                        style: iStyleBlack13700.copyWith(
                                          color: AppColors.text3,
                                        ),
                                      ),
                                      10.pw,
                                      GestureDetector(
                                        onTap: () {
                                          if (user.userId != null) {
                                            Get.to(() => ReportProfileScreen(
                                                userId: user!.userId!));
                                          } else {
                                            Get.snackbar(
                                                "Error", "User ID is null.",
                                                snackPosition:
                                                    SnackPosition.TOP);
                                          }
                                        },
                                        child: Text(
                                          'View Profile',
                                          style: iStyleBlack13700.copyWith(
                                            color: Color(0xFFE47F46),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 340.w,
                                    child: Text(
                                      widget.productReportedModel.reason,
                                      style: iStyleBlack14400.copyWith(
                                        color: AppColors.text3,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  )
                                ]),
                            20.ph
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                30.ph,
                SizedBox(
                  height: 42.h,
                  width: 240.w,
                  child: ElevatedButton(
                    onPressed: () {
                      showCustomDialogToBlock(context,
                          title: 'Sure you want to remove?',
                          message:
                              'Are you sure you want to remove this product?',
                          onConfirm: () {
                        print("Pressed");
                        controller.deleteProduct(
                            widget.productReportedModel.productId,
                            widget.productReportedModel.reportedDesigner);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('REMOVE PRODUCT',
                            style: tSStyleBlack16400.copyWith(
                                color: AppColors.white, fontFamily: 'Inter')),
                        Icon(
                          Icons.east,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ),
                20.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
