import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/user/user_model.dart';
import '../../../controllers/admin_designer_detail_controller.dart';
import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/build_links.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';

class DesignerDetailsScreen extends StatelessWidget {
  final UserModel designer;
  DesignerDetailsScreen({super.key, required this.designer});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }



  @override
  Widget build(BuildContext context) {
    final DesignerDetailsController controller =
        Get.put(DesignerDetailsController(designer));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 72.h,
                width: 430.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      designer.fullName?.toUpperCase() ?? 'No Name',
                      style: tSStyleBlack20400,
                    ),
                    SvgPicture.asset(
                      AppImages.line,
                      color: AppColors.text1,
                    ),
                  ],
                ),
              ),
              10.ph,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.secondary.withOpacity(0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: (designer.imageUrl != null &&
                                designer.imageUrl!.isNotEmpty)
                            ? Image.network(
                                designer.imageUrl!,
                                fit: BoxFit.fitWidth,
                              )
                            : Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: AppColors.secondary.withOpacity(0.5),
                                child: Center(
                                  child: Text(
                                    controller
                                        .getInitials(designer.fullName ?? ''),
                                    style: tSStyleBlack20400.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    19.ph,
                    Text(
                      'About',
                      style: tSStyleBlack16500,
                      textAlign: TextAlign.justify,
                    ),
                    10.ph,
                    Text(
                      designer.about ?? 'No information available',
                      style: tSStyleBlack12400.copyWith(
                        color: AppColors.text1,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    10.ph,
                    Text(
                      'Phone Number',
                      style: tSStyleBlack16400,
                    ),
                    10.ph,
                    BuildLinks(
                      image: AppImages.phone,
                      ontap: () async {
                        await launchUrl(Uri(
                          scheme: 'tel',
                          path: designer.phone,
                        ));
                      },
                      text: designer.phone ?? 'No phone number',
                    ),
                    10.ph,
                    Text(
                      'Email',
                      style: tSStyleBlack16400,
                    ),
                    10.ph,
                    BuildLinks(
                      image: AppImages.mail,
                      ontap: () async {
                        await _launchUrl('mailto:${designer.email}');
                      },
                      text: designer.email ?? 'No email',
                    ),
                    10.ph,
                    if (designer.socialLinks.isNotEmpty) ...[
                      Text(
                        'Social Links',
                        style: tSStyleBlack16400,
                      ),
                      10.ph,
                      ...designer.socialLinks.map((socialLink) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              socialLink['title'] ?? 'No title',
                              style: tSStyleBlack16400,
                            ),
                            10.ph,
                            InkWell(
                              onTap: () {
                                _launchUrl(socialLink['link'] ?? '');
                              },
                              child: Row(
                                children: [
                                  controller
                                      .getSocialIcon(socialLink['link'] ?? ''),
                                  10.pw,
                                  Expanded(
                                    child: Text(
                                      socialLink['link'] ?? 'No link',
                                      style: oStyleBlack14300.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.ph,
                          ],
                        );
                      }).toList(),
                    ],
                    20.ph,
                    SizedBox(
                      height: 42.h,
                      width: 162.w,
                      child: ElevatedButton(
                        onPressed: () {
                          showCustomDialogToBlock(context,
                              title: 'Sure you want to block?',
                              message:
                                  'Are you sure you want to block this user?',
                              onConfirm: () {
                           controller.blockUser(designer);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Block'),
                            Icon(
                              Icons.east,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ),
                    20.ph,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
