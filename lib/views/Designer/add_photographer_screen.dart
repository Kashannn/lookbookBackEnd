import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/controllers/add_photographer_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/custom_app_bar.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';
import '../../utils/components/add_socialLinks.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import 'designer_main_screen.dart';

class AddPhotographerScreen extends StatelessWidget {
  final String productId;
  AddPhotographerScreen({super.key, required this.productId});

  final AddPhotographerController controller =
      Get.put(AddPhotographerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 19.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(),
                30.ph,
                Center(
                  child: Text(
                    'ADD PHOTOGRAPHER',
                    style: tSStyleBlack18400,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    AppImages.line,
                    width: 150.w,
                    height: 15.h,
                    color: AppColors.text1,
                  ),
                ),
                30.ph,
                Obx(
                  () {
                    return Column(
                      children: [
                        controller.selectedImagePath.value.isEmpty
                            ? GestureDetector(
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    controller.selectedImagePath.value =
                                        pickedFile.path;
                                  }
                                },
                                child: Center(
                                  child: Container(
                                    color: const Color(0xFFF6F9FB),
                                    child: DottedBorder(
                                      color: AppColors.secondary,
                                      dashPattern: const [6, 3],
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 90.0.w,
                                          vertical: 55.0.h,
                                        ),
                                        child: SvgPicture.asset(
                                          AppImages.img,
                                          color: AppColors.greylight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Image.file(
                                  File(controller.selectedImagePath.value),
                                  width: MediaQuery.of(context).size.width,
                                  height: 250.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        if (controller.selectedImagePath.value.isEmpty)
                          SizedBox(height: 15.h),
                        if (controller.selectedImagePath.value.isEmpty)
                          Center(
                            child: Text(
                              'Add Image',
                              style: tSStyleBlack18400.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                20.ph,
                Text(
                  'Photographer Name',
                  style: tSStyleBlack16600.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                10.ph,
                textfield(
                  text: 'Name',
                  toHide: false,
                  controller: controller.nameController,
                  focusNode: controller.nameFocusNode,
                  nextFocusNode: controller.socialFocusNode,
                ),
                15.ph,
                Text(
                  'Social Links',
                  style: tSStyleBlack16600.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                10.ph,
                Obx(
                  () => Column(
                    children: List.generate(
                      controller.socialLinks.length,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.socialLinks[index]['title'] ?? '',
                            style: tSStyleBlack16600.copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          5.ph,
                          textfield(
                            text: controller.socialLinks[index]['link'] ?? '',
                            toHide: false,
                            controller: TextEditingController(
                              text: controller.socialLinks[index]['link'] ?? '',
                            ),
                          ),
                          10.ph,
                        ],
                      ),
                    ),
                  ),
                ),
                10.ph,
                Row(
                  children: [
                    Text(
                      'Add Social Links',
                      style: tSStyleBlack14400.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    10.pw,
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.4,
                              minChildSize: 0.3,
                              maxChildSize: 0.8,
                              builder: (_, scrollController) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .unfocus(); // Dismiss keyboard on tap outside
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom, // Adjust for keyboard
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.r),
                                          topRight: Radius.circular(30.r),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15.w,
                                        vertical: 10.h,
                                      ),
                                      child: SingleChildScrollView(
                                        controller:
                                            scrollController, // Enable scrolling with this controller
                                        child: AddSociallinks(
                                          onAdd: (title, link) {
                                            controller.addSocialLink(
                                                title, link);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: SvgPicture.asset(
                        AppImages.add,
                      ),
                    ),
                  ],
                ),
                10.ph,
                Text(
                  'Phone',
                  style: tSStyleBlack16600.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                10.ph,
                textfield(
                  isNumeric: true,
                  text: '023 7878686 33',
                  toHide: false,
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocusNode,
                  nextFocusNode: controller.emailFocusNode,
                ),
                15.ph,
                Text(
                  'Email',
                  style: tSStyleBlack16600.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                10.ph,
                textfield(
                  text: 'Email',
                  toHide: false,
                  controller: controller.emailController,
                  focusNode: controller.emailFocusNode,
                  errorText: controller.emailErrorText,
                ),
                38.ph,
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return controller.isFormComplete.value
                        ? Column(
                            children: [
                              Button(
                                ontap: () {
                                  controller.savePhotographerDetails(productId);
                                },
                                text: 'SAVE',
                                textcolor: AppColors.white,
                                bgColor: AppColors.secondary,
                                borderColor: AppColors.white,
                              ),
                              15.ph,
                              Button(
                                ontap: () {
                                  controller.savePhotographerDetails(productId);
                                },
                                text: 'PREVIEW',
                                textcolor: AppColors.secondary,
                                bgColor: AppColors.white,
                                borderColor: AppColors.secondary,
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 58.h,
                            child: reusedButton(
                              text: 'NEXT',
                              ontap: () {},
                              color: AppColors.greylight,
                              icon: Icons.arrow_forward_outlined,
                            ),
                          );
                  }
                }),
                10.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  String text;
  Color textcolor;
  Color bgColor;
  final void Function()? ontap;
  Color borderColor;
  Button({
    super.key,
    required this.text,
    required this.textcolor,
    required this.bgColor,
    required this.borderColor,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
          side: BorderSide(color: borderColor, width: 1.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
      ),
      onPressed: ontap,
      child: Center(
        child: Text(
          text,
          style: oStyleBlack16600.copyWith(
            color: textcolor,
          ),
        ),
      ),
    );
  }
}
