import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import '../../controllers/All_profile_screen_controller.dart';
import '../../main.dart';
import '../../utils/components/add_socialLinks.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/reusedbutton.dart';
import '../../utils/components/textfield.dart';

class AdditionalInformationForm extends StatefulWidget {
  const AdditionalInformationForm({super.key});

  @override
  State<AdditionalInformationForm> createState() =>
      _AdditionalInformationFormState();
}

class _AdditionalInformationFormState extends State<AdditionalInformationForm> {
  final AllProfileScreenController controller =
      Get.put(AllProfileScreenController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primaryColor,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 60.0.h,
                  right: 34.0.w,
                  left: 34.0.w,
                  bottom: 30.0.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FILL YOUR MISSING INFORMATION',
                      style: aStyleBlack28800.copyWith(
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
                            "REQUIRED FIELDS",
                            style: tSStyleBlack16400.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.ph,
            Center(
              child: Text(
                'I N F O R M A T I O N',
                style: tSStyleBlack18500,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                AppImages.line,
                color: AppColors.text1,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 10.h),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: tSStyleBlack16400.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              15.ph,
                              CustomTextField(
                                text: 'name',
                                toHide: false,
                                controller: controller.nameController,
                              ),
                              15.ph,
                              Text(
                                'Phone Number',
                                style: tSStyleBlack16400.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              15.ph,
                              CustomTextField(
                                text: 'phone',
                                toHide: false,
                                controller: controller.phoneController,
                              ),
                              15.ph,
                              Text(
                                'About',
                                style: tSStyleBlack16400.copyWith(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              15.ph,
                              CustomTextField(
                                text: 'About',
                                toHide: false,
                                minLines: 1,
                                maxLines: null,
                                controller: controller.aboutController,
                              ),
                              30.ph,
                              Obx(
                                () => Column(
                                  children: List.generate(
                                    controller.socialLinks.length,
                                    (index) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.socialLinks[index]
                                                  ['title'] ??
                                              '',
                                          style: tSStyleBlack16400.copyWith(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                        ),
                                        15.ph,
                                        CustomTextField(
                                          text: 'Link',
                                          toHide: false,
                                          controller: TextEditingController(
                                            text: controller.socialLinks[index]
                                                ['link'],
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
                                              FocusScope.of(context).unfocus();
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
                                                      controller.addSocialLink(
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
                                    ? CircularProgressIndicator()
                                    : SizedBox(
                                        child: reusedButton2(
                                          text: 'SAVE',
                                          ontap: () async {
                                            await controller.updateUserData();
                                            Get.offAll(() => AuthWrapper());
                                          },
                                          color: AppColors.secondary,
                                        ),
                                      );
                              }),
                              30.ph,
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
