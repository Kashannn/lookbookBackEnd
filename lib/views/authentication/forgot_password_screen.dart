import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';

import '../../controllers/forgot_password_screen_controller.dart';
import '../../utils/components/constant/app_textstyle.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller =
      Get.put(ForgotPasswordController());
  final FocusNode forgotFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Password',
                style: aStyleBlack32400.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              5.ph,
              Text(
                'Enter your email for the verification process, we will send you an email.',
                style: tSStyleBlack16400.copyWith(
                  color: AppColors.text2,
                ),
              ),
              30.ph,
              Text(
                'Email',
                style: tSStyleBlack16400.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              10.ph,
              textfield(
                text: 'Type Email',
                toHide: false,
                controller: controller.forgotPasswordController,
                focusNode: forgotFocusNode,
              ),
              20.ph,
              Obx(
                () => SizedBox(
                  height: 58.h,
                  width: double.infinity,
                  child: reusedButton(
                    icon: Icons.arrow_forward_outlined,
                    text: 'CONTINUE',
                    ontap: controller.isButtonActive.value
                        ? controller.submit
                        : null,
                    color: controller.isButtonActive.value
                        ? AppColors.secondary
                        : AppColors.greylight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
