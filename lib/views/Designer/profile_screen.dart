import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/reusedbutton.dart';
import 'package:lookbook/utils/components/textfield.dart';
import 'package:lookbook/controllers/all_profile_screen_controller.dart';

import '../../utils/components/add_socialLinks.dart';
import '../../utils/components/constant/app_images.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AllProfileScreenController controller =
      Get.put(AllProfileScreenController());
  @override
  Widget build(BuildContext context) {
    String getInitials(String name) {
      List<String> nameParts = name.split(' ');
      if (nameParts.length >= 2) {
        return nameParts[0][0] + nameParts[1][0];
      } else if (nameParts.isNotEmpty) {
        return nameParts[0][0];
      }
      return '';
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 26.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    'P R O F I L E',
                    style: tSStyleBlack18500,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    AppImages.line,
                    color: AppColors.text1,
                  ),
                ),
                70.ph,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0.w,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 10.0.w,
                              right: 10.0.w,
                              top: 100.0.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  text: 'name',
                                  toHide: false,
                                  optionalSvgIcon: AppImages.UpdateProfileIcon,
                                  controller: controller.nameController,
                                ),
                                15.ph,
                                CustomTextField(
                                  text: 'phone',
                                  toHide: false,
                                  optionalSvgIcon: AppImages.UpdateProfileIcon,
                                  controller: controller.phoneController,
                                ),
                                15.ph,
                                CustomTextField(
                                  text: 'About',
                                  toHide: false,
                                  minLines: 1,
                                  maxLines: null,
                                  optionalSvgIcon: AppImages.UpdateProfileIcon,
                                  controller: controller.aboutController,
                                ),
                                15.ph,
                                Obx(
                                  () => Column(
                                    children: List.generate(
                                      controller.socialLinks.length,
                                      (index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomTextField(
                                            minLines: 1,
                                            maxLines: null,
                                            optionalSvgIcon:
                                                AppImages.UpdateProfileIcon,
                                            text: 'Link',
                                            toHide: false,
                                            controller: TextEditingController(
                                              text: controller
                                                  .socialLinks[index]['link'],
                                            ),
                                            onChanged: (value) {
                                              controller.socialLinks[index]
                                                  ['link'] = value;
                                            },
                                          ),
                                          15.ph,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                          clipBehavior: Clip.antiAlias,
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (BuildContext context) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30.r),
                                                      topRight:
                                                          Radius.circular(30.r),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15.w,
                                                    vertical: 10.h,
                                                  ),
                                                  child: Wrap(children: [
                                                    AddSociallinks(
                                                      onAdd: (title, link) {
                                                        controller
                                                            .addSocialLink(
                                                                title, link);
                                                      },
                                                    ),
                                                  ]),
                                                ),
                                              ),
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
                                30.ph,
                                Obx(() {
                                  return controller.isUpdating.value
                                      ? SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.secondary,
                                              shadowColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 10,
                                              ),
                                            ),
                                            onPressed: null,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(
                                                              0xFFE47F46)), // Custom color for the loader
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          child: reusedButton2(
                                            text: 'UPDATE',
                                            ontap: () {
                                              controller.updateUserData();
                                            },
                                            color: AppColors.secondary,
                                          ),
                                        );
                                }),
                                30.ph,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -45.h,
                        left: MediaQuery.of(context).size.width * 0.5 - 70.w,
                        child: Obx(() {
                          return controller.isLoading.value
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: CircleAvatar(
                                    radius: 60.0.r,
                                    backgroundColor: Colors.grey,
                                  ),
                                )
                              : Center(
                                  child: CircleAvatar(
                                    radius: 60.0.r,
                                    backgroundColor:
                                        AppColors.secondary.withOpacity(0.5),
                                    child: controller.selectedProfileImage !=
                                            null
                                        ? ClipOval(
                                            child: Image.file(
                                              controller.selectedProfileImage!,
                                              fit: BoxFit.cover,
                                              width: 120.0.w,
                                              height: 120.0.h,
                                            ),
                                          )
                                        : (controller.profileImageUrl != null &&
                                                controller
                                                    .profileImageUrl!.isNotEmpty
                                            ? ClipOval(
                                                child: Image.network(
                                                  controller.profileImageUrl!,
                                                  fit: BoxFit.cover,
                                                  width: 120.0.w,
                                                  height: 120.0.h,
                                                ),
                                              )
                                            : Container(
                                                width: 120.0.w,
                                                height: 120.0.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondary
                                                      .withOpacity(0.5),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    getInitials(controller
                                                        .nameController.text),
                                                    style: tSStyleBlack18500
                                                        .copyWith(
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                  ),
                                );
                        }),
                      ),
                      Positioned(
                        top: 40.h,
                        left: MediaQuery.of(context).size.width * 0.5 + 15.w,
                        child: Container(
                          height: 30.0.h,
                          width: 30.0.w,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(6.0.r),
                          ),
                          child: IconButton(
                            icon: SvgPicture.asset(
                                height: 35.0.h,
                                width: 35.0.w,
                                AppImages.UpdateProfileIcon,
                                color: AppColors.profileIcon),
                            onPressed: () {
                              controller.uploadProfilePicture();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                20.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
