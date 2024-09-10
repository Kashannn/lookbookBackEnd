import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';

class CreateWithController extends GetxController {
  var selectedButton = ''.obs;

  void updateButtonSelection(String button) {
    selectedButton.value = button;
  }
}

class CreateWithScreen extends StatelessWidget {
  const CreateWithScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateWithController());
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              AppImages.splash,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 40.0.h,
              horizontal: 24.0.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'CREATE WITH',
                    style: aStyleBlack48400,
                  ),
                ),
                20.ph,
                Obx(
                  () => SizedBox(
                    height: 58.h,
                    child: reusedButton(
                      icon: Icons.arrow_forward_outlined,
                      text: 'DESIGNER',
                      ontap: () {
                        controller.updateButtonSelection('designer');
                        Get.toNamed('signup', arguments: 'DESIGNER');
                      },
                      color: controller.selectedButton.value == 'designer'
                          ? AppColors.secondary
                          : AppColors.greylight,
                    ),
                  ),
                ),
                15.ph,
                Obx(
                  () => SizedBox(
                    height: 58.h,
                    child: reusedButton(
                      icon: Icons.arrow_forward_outlined,
                      text: 'CUSTOMER',
                      ontap: () {
                        controller.updateButtonSelection('customer');
                        Get.toNamed('signup', arguments: 'CUSTOMER');
                      },
                      color: controller.selectedButton.value == 'customer'
                          ? AppColors.secondary
                          : AppColors.greylight,
                    ),
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
