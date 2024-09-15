import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';

import 'constant/app_images.dart';

class BuildList extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback ontap;

  BuildList({
    super.key,
    required this.image,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: _buildImage(),
          ),
        ),
        10.pw,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              style: tSStyleBlack14500,
            ),
            5.ph,
            SizedBox(
              height: 28.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.r),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                ),
                onPressed: ontap,
                child: SizedBox(
                  width: 80.w,
                  height: 20.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'VIEW',
                        style:
                            oStyleBlack12600.copyWith(color: AppColors.white),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColors.white,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildImage() {
    if (image.startsWith('http') || image.startsWith('https')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        width: 60.0,
        height: 60.0,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(AppImages.profile, fit: BoxFit.cover);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator();
        },
      );
    } else {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        width: 60.0,
        height: 60.0,
      );
    }
  }
}
