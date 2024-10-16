import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lookbook/controllers/menu_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';

import '../../Firebase/firebase_authentication_services.dart';

class AdminCustomMenu extends StatelessWidget {
  AdminCustomMenu({super.key});
  final FirebaseAuthenticationServices _firebaseAuthenticationServices =
      Get.put(FirebaseAuthenticationServices());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0.w,
            vertical: 20.0.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOOK',
                style: aStyleBlack20800.copyWith(
                  color: const Color(0xFF515152),
                ),
              ),
              Text(
                '      BOOK',
                style: aStyleBlack20800,
              ),
              SizedBox(
                height: 38.0.h,
              ),
              Text(
                'About Fashion Concierge',
                style: oStyleBlack18600.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(
                height: 12.0.h,
              ),
              Text(
                'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products',
                style: tSStyleBlack16400,
              ),
              SizedBox(
                height: 12.0.h,
              ),
              Text(
                'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products',
                style: tSStyleBlack16400,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    // side: const BorderSide(color: AppColors.white, width: 1.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 8,
                  ),
                ),
                onPressed: () {
                  _firebaseAuthenticationServices.signOut();
                },
                child: Text(
                  'LOGOUT',
                  style: tSStyleBlack14400.copyWith(color: AppColors.white),
                ),
              ),
              20.ph,
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final int index;

  const Menu({
    super.key,
    required this.text,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final CustomMenuController controller = Get.put(CustomMenuController());

    return Obx(
      () => InkWell(
        onTap: () {
          controller.setSelectedIndex(index);
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.tenorSans(
                color: controller.selectedIndex.value == index
                    ? AppColors.secondary
                    : const Color(0xFF333333),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (controller.selectedIndex.value == index)
              Container(
                margin: const EdgeInsets.only(top: 2.0),
                height: 2.0,
                color: AppColors.secondary,
                width: _getTextWidth(text, context),
              ),
          ],
        ),
      ),
    );
  }

  double _getTextWidth(String text, BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.tenorSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }
}
