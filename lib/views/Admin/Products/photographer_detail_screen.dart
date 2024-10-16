import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/AddProductModel/add_photographer_model.dart';
import '../../../utils/components/build_links.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';

class PhotographerDetailScreen extends StatelessWidget {
  final AddPhotographerModel photographer;

  const PhotographerDetailScreen({
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 72.h,
                    width: 430.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          photographer.name?.toUpperCase() ?? 'No Name',
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
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.secondary.withOpacity(0.5),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        Image.network(
                          photographer.image ?? AppImages.profile,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(AppImages.profile,
                                fit: BoxFit.cover);
                          },
                        ),
                      ],
                    ),
                  ),
                  15.ph,
                  Text(
                    'About',
                    style: tSStyleBlack16500,
                    textAlign: TextAlign.justify,
                  ),
                  10.ph,
                  Text(
                    photographer.about ?? 'No information available',
                    style: tSStyleBlack12400.copyWith(
                      color: AppColors.text1,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  15.ph,
                  Text(
                    'Phone Number',
                    style: tSStyleBlack16500,
                    textAlign: TextAlign.justify,
                  ),
                  10.ph,
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
                  Text(
                    'Email',
                    style: tSStyleBlack16500,
                    textAlign: TextAlign.justify,
                  ),
                  10.ph,
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
                  Text(
                    'Social Links',
                    style: tSStyleBlack16500,
                    textAlign: TextAlign.justify,
                  ),
                  10.ph,
                  _buildSocialLinks(photographer.socialLinks),
                  20.ph,
                ],
              ),
            ),
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
}
