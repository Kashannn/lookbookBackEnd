import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';
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
                    Image.network(
                      photographer.image ?? AppImages.profile,
                      width: MediaQuery.of(context).size.width,
                      height: 200.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(AppImages.profile, fit: BoxFit.cover);
                      },
                    ),
                  ],
                ),
              ),
              15.ph,
              Text(
                photographer.name ?? 'Unknown',
                style: tSStyleBlack16400,
              ),
              15.ph,
              BuildLinks(
                image: AppImages.phone,
                ontap: () {},
                text: photographer.phone ?? 'No phone available',
              ),
              15.ph,
              BuildLinks(
                image: AppImages.mail,
                ontap: () {},
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
        return BuildLinks(
          image: AppImages.social,
          ontap: () {},
          text: '$title: $url',
        );
      }).toList(),
    );
  }
}

