import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';

import 'constant/app_images.dart';

class BuildList extends StatelessWidget {
  final String? image; // Make image nullable
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18.0,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: _buildImage(), // Call updated _buildImage method
              ),
            ),
            10.pw, // Placeholder for spacing
            Expanded(
              child: Text(
                text,
                style: tSStyleBlack14500,
                maxLines: 1,
              ),
            ),
            Text(".", style: TextStyle(color: Colors.white)),
            5.ph // Placeholder for spacing
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 50.0.w),
          child: SizedBox(
            height: 32.h,
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
                      style: oStyleBlack12600.copyWith(color: AppColors.white),
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
          ),
        )
      ],
    );
  }

  Widget _buildImage() {
    // If the image is null, empty or doesn't start with 'http', we'll show the initials
    if (image == null ||
        image!.isEmpty ||
        !(image!.startsWith('http') || image!.startsWith('https'))) {
      // Show initials if image is not available
      String initials = text.isNotEmpty
          ? text
              .substring(0, 2)
              .toUpperCase() // Take first 2 letters of the name
          : 'NA'; // Default to 'NA' if name is not available

      return CircleAvatar(
        radius: 18.0,
        backgroundColor: Colors.grey,
        child: Text(
          initials,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return Image.network(
        image!,
        fit: BoxFit.cover,
        width: 60.0,
        height: 60.0,
        errorBuilder: (context, error, stackTrace) {
          // If loading fails, fallback to initials
          String initials =
              text.isNotEmpty ? text.substring(0, 2).toUpperCase() : 'NA';
          return CircleAvatar(
            radius: 18.0,
            backgroundColor: Colors.grey,
            child: Text(
              initials,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        },
      );
    }
  }
}
