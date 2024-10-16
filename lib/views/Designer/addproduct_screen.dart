import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';

import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 26.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'ADD PRODUCT',
                      style: tSStyleBlack18400,
                    ),
                  ),
                  Center(
                    child: SvgPicture.asset(
                      AppImages.line,
                      color: AppColors.text1,
                    ),
                  ),
                  100.ph,
                  Center(
                    child: SvgPicture.asset(
                      AppImages.shopping,
                      width: 192.w,
                      height: 192.h,
                    ),
                  ),
                  20.ph,
                  SizedBox(
                    height: 58.h,
                    child: reusedButton(
                      icon: Icons.add,
                      text: "ADD NEW PRODUCT",
                      ontap: () {
                        Get.toNamed('addProduct1');
                      },
                      color: AppColors.secondary,
                    ),
                  ),
                  10.ph,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
