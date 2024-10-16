import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import '../../Notification/notification.dart';
import 'constant/app_textstyle.dart';

class AdminCustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  AdminCustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationService notificationService = NotificationService();
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
            icon: SvgPicture.asset(
              selectedIndex == 1
                  ? AppImages.messageIcon2
                  : AppImages.messageIcon,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    selectedIndex == 2
                        ? AppImages.notificationIcon2
                        : AppImages.notificationIcon,
                  ),
                ),
                StreamBuilder<int>(
                  stream: notificationService.getUnreadNotificationCount(
                      FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data! > 0) {
                      return Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
            label: 'Notification',
          ),
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
        unselectedItemColor: AppColors.primaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: qStyleBlack12500,
      ),
    );
  }
}
