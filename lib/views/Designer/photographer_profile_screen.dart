import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:path/path.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/AddProductModel/add_photographer_model.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/build_links.dart';

class PhotographerProfileScreen extends StatelessWidget {
  final AddPhotographerModel photographer;

  const PhotographerProfileScreen({
    Key? key,
    required this.photographer,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    String initials = _getInitials(photographer.name ?? 'Unknown');
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
                        // height: 200.h,
                        color: Colors.grey[300],
                      ),
                    ),
                    photographer.image != null && photographer.image!.isNotEmpty
                        ? Image.network(
                            photographer.image!,
                            width: MediaQuery.of(context).size.width,
                            // height: 200.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(AppImages.profile,
                                  fit: BoxFit.cover);
                            },
                          )
                        : _buildInitials(initials),
                  ],
                ),
              ),
              15.ph,
              Text(
                photographer.name!.toUpperCase() ?? 'Unknown',
                style: tSStyleBlack16400,
              ),
              5.ph,
              Text(
                photographer.about ?? '',
                style: tSStyleBlack12400,
                textAlign: TextAlign.justify,
              ),
              15.ph,
              BuildLinks(
                image: AppImages.phone,
                ontap: () async {
                  await launchUrl(Uri(
                    scheme: 'tel',
                    path: photographer.phone,
                  ));
                },
                text: photographer.phone ?? 'No phone available',
              ),
              15.ph,
              BuildLinks(
                image: AppImages.mail,
                ontap: () async {
                  await launchUrl(Uri(
                    scheme: 'mailto',
                    path: photographer.email,
                  ));
                },
                text: photographer.email ?? 'No email available',
              ),
              15.ph,
              _buildSocialLinks(photographer.socialLinks),
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
        return GestureDetector(
          onTap: () {
            _launchUrl(url);
          },
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

  // Helper function to build initials
  Widget _buildInitials(String initials) {
    return Container(
      width: double.infinity,
      height: 200.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.rectangle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Function to get initials from the name
  String _getInitials(String name) {
    List<String> parts = name.trim().split(' ');
    String initials = '';
    if (parts.isNotEmpty) {
      initials += parts[0][0].toUpperCase(); // First initial
    }
    if (parts.length > 1) {
      initials += parts[1][0].toUpperCase(); // Second initial
    }
    return initials.isNotEmpty
        ? initials
        : 'NA'; // Return 'NA' if no initials found
  }
}
