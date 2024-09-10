import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/controllers/sign_in_screen_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';
import 'package:lookbook/views/Admin/admin_main_screen.dart';

import '../../Model/user/user_model.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/socialbuttons.dart';
import '../Customer/customer_main_screen.dart';
import '../Designer/designer_main_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final SignInController controller = Get.put(SignInController());
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    top: 110.0.h,
                    right: 34.0.w,
                    left: 34.0.w,
                    bottom: 30.0.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN ACCOUNT',
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
                          Get.toNamed('createwith');
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Don’t have an account? Signup",
                              style: tSStyleBlack16400.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10.0.w,
                            ),
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
              10.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => AdminMainScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.secondary),
                    child: Text('Admin'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => CustomerMainScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.secondary),
                    child: Text('Customer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => DesignerMainScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.secondary),
                    child: Text('Designer'),
                  ),
                ],
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
                      'Email',
                      style: tSStyleBlack16400,
                    ),
                    10.ph,
                    textfield(
                      text: 'Type Email',
                      toHide: false,
                      controller: controller.emailController,
                      focusNode: emailFocusNode,
                      nextFocusNode: passwordFocusNode,
                      errorText: controller.emailErrorText,
                    ),
                    15.ph,
                    Text(
                      'Password',
                      style: tSStyleBlack16400,
                    ),
                    10.ph,
                    textfield(
                      text: 'Type Password',
                      toHide: true,
                      controller: controller.passwordController,
                      focusNode: passwordFocusNode,
                      errorText: controller.passwordErrorText,
                    ),
                    30.ph,
                    Obx(
                      () => controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.secondary,
                              ),
                            )
                          : SizedBox(
                              height: 58.h,
                              child: reusedButton(
                                icon: Icons.arrow_forward_outlined,
                                text: 'LOGIN NOW!',
                                ontap: controller.isButtonActive.value
                                    ? () async {
                                        UserModel? user =
                                            await controller.signIn();
                                        if (user != null) {}
                                      }
                                    : null,
                                color: controller.isButtonActive.value
                                    ? AppColors.secondary
                                    : AppColors.greylight,
                              ),
                            ),
                    ),
                    18.ph,
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.r),
                            side: const BorderSide(
                              color: AppColors.greylight,
                              width: 1.0,
                            ),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return DraggableScrollableSheet(
                                expand: false,
                                builder: (_, controller) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24.w, vertical: 16.h),
                                    child: ForgotPasswordScreen(),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          'Forgot Password',
                          style: tSStyleBlack14400,
                        ),
                      ),
                    ),
                    30.ph,
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: AppColors.grey1,
                            thickness: 1.5,
                          ),
                        ),
                        Text(
                          'OR',
                          style: tSStyleBlack14400.copyWith(
                            color: const Color(0xFF212121),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: AppColors.grey1,
                            thickness: 1.5,
                          ),
                        ),
                      ],
                    ),
                    30.ph,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialbuttons(
                          image: AppImages.googlelogo,
                          ontap: () {},
                        ),
                        SizedBox(
                          width: 22.0.w,
                        ),
                        socialbuttons(
                          image: AppImages.applelogo,
                          ontap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
