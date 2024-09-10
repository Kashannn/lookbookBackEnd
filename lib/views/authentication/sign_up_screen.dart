import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/sign_up_screen_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';

import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/name_field.dart';
import '../../utils/components/textfield.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final SignUpController controller = Get.put(SignUpController());
  final role = Get.arguments as String;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryColor,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 120.0.h,
                  right: 34.0.w,
                  left: 34.0.w,
                  bottom: 30.0.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN UP',
                      style: aStyleBlack48400.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    10.ph,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                          side: const BorderSide(
                              color: AppColors.white, width: 1.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                      ),
                      onPressed: () {
                        Get.toNamed('signin');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account? Login",
                            style: tSStyleBlack16400.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          10.ph,
                          const Icon(
                            Icons.arrow_forward_outlined,
                            color: AppColors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0.w,
                vertical: 24.0.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name',
                    style: tSStyleBlack16400.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  10.ph,
                  Obx(
                    () => NameField(
                      text: 'Type Full Name',
                      toHide: false,
                      controller: controller.nameController,
                      focusNode: controller.nameFocusNode,
                      nextFocusNode: controller.emailFocusNode,
                      errorText: controller.nameErrorText,
                    ),
                  ),
                  15.ph,
                  Text(
                    'Type Email',
                    style: tSStyleBlack16400.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  10.ph,
                  Obx(
                    () => textfield(
                      text: 'Type Email',
                      toHide: false,
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      nextFocusNode: controller.passwordFocusNode,
                      errorText: controller.emailErrorText,
                    ),
                  ),
                  15.ph,
                  Text(
                    'Password',
                    style: tSStyleBlack16400.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  10.ph,
                  Obx(
                    () => textfield(
                      text: 'Type Password',
                      toHide: true,
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      nextFocusNode: controller.confirmFocusNode,
                      errorText: controller.passwordErrorText,
                    ),
                  ),
                  15.ph,
                  Text(
                    'Confirm Password',
                    style: tSStyleBlack16400.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  10.ph,
                  Obx(
                    () => textfield(
                      text: 'Type Confirm Password',
                      toHide: true,
                      controller: controller.confirmController,
                      focusNode: controller.confirmFocusNode,
                      errorText: controller.confirmErrorText,
                    ),
                  ),
                  40.ph,
                  Obx(
                    () => SizedBox(
                      height: 58.h,
                      child: reusedButton(
                        icon: Icons.arrow_forward_outlined,
                        text: 'SIGNUP NOW!',
                        ontap: controller.isButtonActive.value
                            ? () {
                                controller.signUp(role);
                              }
                            : null,
                        color: controller.isButtonActive.value
                            ? AppColors.secondary
                            : AppColors.greylight,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
