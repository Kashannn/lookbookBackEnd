import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';

import '../../controllers/chat_controller.dart';
import 'constant/app_images.dart';

class CustomerCustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  final ChatController chatController = Get.put(ChatController());

  CustomerCustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
          right: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: BottomAppBar(
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IconButton(
                  icon: SvgPicture.asset(
                    selectedIndex == 0 ? AppImages.homeIcon2 : AppImages.homeIcon,
                  ),
                  onPressed: () => onTap(0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, top: 10.h),
                child: Stack(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        selectedIndex == 1
                            ? AppImages.messageIcon2
                            : AppImages.messageIcon,
                      ),
                      onPressed: () => onTap(1),
                    ),
                    Obx(() {
                      if (chatController.unreadMessageCount.value == 0) {
                        return SizedBox.shrink();
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
                  ],
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: SvgPicture.asset(
                    selectedIndex == 3
                        ? AppImages.profileIcon2
                        : AppImages.profileIcon,
                  ),
                  onPressed: () => onTap(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
