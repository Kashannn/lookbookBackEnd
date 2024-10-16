import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/chat_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import 'constant/app_images.dart';
import 'constant/app_textstyle.dart';

class DesignerBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const DesignerBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.put(ChatController());

    return Container(
      height: 96.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: BottomNavigationBar(
        backgroundColor: AppColors.white,
        currentIndex: selectedIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedIndex == 0 ? AppImages.homeIcon2 : AppImages.homeIcon,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                SvgPicture.asset(
                  selectedIndex == 1
                      ? AppImages.messageIcon2
                      : AppImages.messageIcon,
                ),
                Positioned(
                  right: 0,
                  child: Obx(() {
                    if (chatController.unreadMessageCount.value == 0) {
                      return SizedBox
                          .shrink(); // Don't show badge if unread count is 0
                    }
                    return CircleAvatar(
                      radius: 10.0,
                      backgroundColor: Colors.red,
                      child: Text(
                        chatController.unreadMessageCount.value.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            label: 'Message',
          ),

          // BottomNavigationBarItem(
          //   icon:  SvgPicture.asset(
          //     selectedIndex == 2
          //         ? AppImages.notificationIcon2
          //         : AppImages.notificationIcon,
          //   ),
          //
          //   label: 'Notification',
          // ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedIndex == 3
                  ? AppImages.profileIcon2
                  : AppImages.profileIcon,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: qStyleBlack12500,
      ),
    );
  }
}
