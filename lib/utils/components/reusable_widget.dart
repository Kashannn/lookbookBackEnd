import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';
import '../../views/Admin/Reports/Message_report_screen.dart';
import '../../views/Designer/designer_message_report_screen.dart';
import 'constant/app_colors.dart';
import 'constant/app_textstyle.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;
  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            // height: 226.h,
            width: 187.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Color(0x29000000),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: imagePath.isNotEmpty
                  ? Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 187.w,
                      height: 226.h,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 187.w,
                            height: 226.h,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 187.w,
                          color: Colors.grey,
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 187.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.grey,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),
          10.ph,
          Container(
            width: 187.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: tSStyleBlack14400,
                ),
                Text(
                  subtitle,
                  style: tSStyleBlack14400,
                ),
                Text(
                  price,
                  style: tSStyleBlack20400.copyWith(
                    color: Color(0xFFDD8560),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;

  const FullScreenImageViewer({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 8.0,
            child: Image.network(
              imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard2 extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;

  const ProductCard2({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x29000000),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0),
                ),
              ],
            ),
            child: imagePath.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 180.h,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 180.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              topRight: Radius.circular(10.r),
                            ),
                            color: Colors.grey,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        topRight: Radius.circular(10.r),
                      ),
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x29000000),
                  blurRadius: 4.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 4.0),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 4.0),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: tSStyleBlack14400,
                      maxLines: 1,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 3.w, top: 5.h, bottom: 5.h),
                      child: Text(
                        subtitle,
                        style: tSStyleBlack10400,
                        maxLines: 1,
                      ),
                    ),
                    Text(
                      price,
                      style: tSStyleBlack20400.copyWith(
                        color: Color(0xFFDD8560),
                      ),
                    ),
                    5.ph,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showCustomPopupMenu(
    BuildContext context, Offset position, ReportsModel model) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  showMenu(
    color: Colors.transparent,
    elevation: 0,
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy - 10.h,
      overlay.size.width - position.dx,
      overlay.size.height - position.dy,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Rounded corners
    ),
    items: [
      PopupMenuItem(
        value: 'report',
        child: Container(
          height: 38.h,
          width: 150.w,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Report',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: AppColors.secondary,
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    ],
  ).then((value) {
    if (value == 'report') {
      Get.to(() => DesignerMessageReportScreen(
            reportsModel: model,
          ));
    }
  });
}
