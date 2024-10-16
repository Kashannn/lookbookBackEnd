// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/Model/AddProductModel/add_product_model.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/build_links.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import 'package:lookbook/utils/components/constant/app_textstyle.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class DesignerProfileScreen extends StatelessWidget {
  final UserModel designer;
  final AddProductModel? product;
  DesignerProfileScreen({super.key, required this.designer, this.product});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url); // Convert the string to a Uri object
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 150.0.w,
                  child: const Divider(
                    thickness: 3,
                    color: AppColors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              Center(
                child: Stack(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200.h,
                        color: Colors.grey[300],
                      ),
                    ),
                    // Use the Image.network and handle the error
                    Image.network(
                      designer.imageUrl ?? '',
                      width: MediaQuery.of(context).size.width,
                      // height: 200.h,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200.h,
                          alignment: Alignment.center,
                          color: Colors
                              .grey[300], // Background color for placeholder
                          child: Text(
                            getInitials(designer.fullName ??
                                'Unknown'), // Get initials from designer's name
                            style: TextStyle(
                              fontSize: 40, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // Change text color for better visibility
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              15.ph,
              Text(
                designer.fullName!.toUpperCase() ?? 'Unknown',
                style: tSStyleBlack16400,
              ),
              5.ph,
              Text(
                designer.about ?? '',
                style: tSStyleBlack12400,
                textAlign: TextAlign.justify,
              ),
              15.ph,
              BuildLinks(
                image: AppImages.phone,
                ontap: () async {
                  await launchUrl(Uri(
                    scheme: 'tel',
                    path: designer.phone.toString(),
                  ));
                },
                text: designer.phone.toString() ?? 'No phone available',
              ),
              15.ph,
              BuildLinks(
                image: AppImages.mail,
                ontap: () async {
                  await launchUrl(Uri(
                    scheme: 'mailto',
                    path: designer.email,
                  ));
                },
                text: designer.email ?? 'No email available',
              ),
              15.ph,
              _buildSocialLinks(designer!.socialLinks),
              20.ph,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks(List<Map<String, String?>> socialLinks) {
    if (socialLinks.isEmpty) {
      return const Text('No social links available.');
    }
    return Column(
      children: socialLinks.map((link) {
        final title = link['title'] ?? 'Unknown';
        final url = link['link'] ?? 'N/A';
        return Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Row(
            children: [
              _getSocialIcon(url),
              10.pw,
              Expanded(
                child: Text(
                  url,
                  style: oStyleBlack14300.copyWith(
                    color: AppColors.text1,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              10.pw,
              const Icon(
                Icons.arrow_forward,
                color: AppColors.secondary,
                size: 18,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  SvgPicture _getSocialIcon(String url) {
    if (url.contains('facebook')) {
      return SvgPicture.asset(
        AppImages.facebook,
      );
    } else if (url.contains('instagram')) {
      return SvgPicture.asset(
        AppImages.social,
      );
    } else if (url.contains('whatsapp')) {
      return SvgPicture.asset(
        AppImages.whatsapp,
      );
    } else if (url.contains('snapchat')) {
      return SvgPicture.asset(
        AppImages.snapchat,
      );
    } else if (url.contains('tiktok')) {
      return SvgPicture.asset(
        AppImages.tiktok,
      );
    } else if (url.contains('youtube')) {
      return SvgPicture.asset(
        AppImages.youTube,
      );
    } else if (url.contains('linkedin')) {
      return SvgPicture.asset(
        AppImages.linkedIn,
      );
    } else if (url.contains('twitter')) {
      return SvgPicture.asset(
        AppImages.twitter,
      );
    } else if (url.contains('pinterest')) {
      return SvgPicture.asset(
        AppImages.pinterest,
      );
    } else {
      // Default icon for unknown links
      return SvgPicture.asset(
        'assets/icons/link.svg',
      );
    }
  }
}
