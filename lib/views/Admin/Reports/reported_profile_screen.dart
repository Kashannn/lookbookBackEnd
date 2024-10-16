import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/report_profile_controller.dart';
import '../../../utils/components/build_links.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';

class ReportProfileScreen extends StatelessWidget {
  final String? userId;
  final ReportProfileController controller = Get.put(ReportProfileController());

  ReportProfileScreen({super.key, required this.userId}) {
    if (userId != null) {
      controller.fetchUserDetails(userId!);
    }
  }
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
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
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                final userModel = controller.userModel;

                return Column(
                  children: [
                    SizedBox(
                      height: 72,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            userModel?.fullName ?? 'No Name',
                            style: tSStyleBlack20400,
                          ),
                          SvgPicture.asset(
                            AppImages.line,
                            color: AppColors.text1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.cyan,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: userModel?.imageUrl != null &&
                                      userModel!.imageUrl!.isNotEmpty
                                  ? Stack(
                                      children: [
                                        // Show shimmer effect while image is loading
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: double.infinity,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        // Network Image
                                        Positioned.fill(
                                          child: Image.network(
                                            userModel!.imageUrl!,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: double.infinity,
                                                height: 300,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    getInitials(
                                                        userModel?.fullName ??
                                                            'NA'),
                                                    style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          getInitials(
                                              userModel?.fullName ?? 'NA'),
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 19),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  userModel?.fullName ?? 'No Name',
                                  style: tSStyleBlack16400,
                                ),
                                10.ph,
                                Text(
                                  userModel?.about ?? 'No bio available',
                                  style: tSStyleBlack12400.copyWith(
                                    color: AppColors.text1,
                                  ),
                                ),
                                15.ph,
                                Text(
                                  'Phone Number',
                                  style: tSStyleBlack16500,
                                ),
                                10.ph,
                                BuildLinks(
                                  image: AppImages.phone,
                                  ontap: () async {
                                    await launchUrl(Uri(
                                      scheme: 'tel',
                                      path: userModel?.phone,
                                    ));
                                  },
                                  text: userModel?.phone ?? 'No phone number',
                                ),
                                15.ph,
                                Text(
                                  'Email',
                                  style: tSStyleBlack16500,
                                ),
                                10.ph,
                                BuildLinks(
                                  image: AppImages.mail,
                                  ontap: () async {
                                    await _launchUrl(
                                        'mailto:${userModel?.email}');
                                  },
                                  text: userModel?.email ?? 'No email',
                                ),
                                15.ph,
                                if (userModel!.socialLinks.isNotEmpty) ...[
                                  Text(
                                    'Social Links',
                                    style: tSStyleBlack16400,
                                  ),
                                  10.ph,
                                  ...userModel!.socialLinks.map((socialLink) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          socialLink['title'] ?? 'No title',
                                          style: tSStyleBlack16400,
                                        ),
                                        10.ph,
                                        InkWell(
                                          onTap: () {
                                            _launchUrl(
                                                socialLink['link'] ?? '');
                                          },
                                          child: Row(
                                            children: [
                                              controller.getSocialIcon(
                                                  socialLink['link'] ?? ''),
                                              10.pw,
                                              Expanded(
                                                child: Text(
                                                  socialLink['link'] ??
                                                      'No link',
                                                  style:
                                                      oStyleBlack14300.copyWith(
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
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
