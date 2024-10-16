import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookbook/utils/components/admin_custom_bottom_navigation_bar.dart';
import 'package:lookbook/utils/components/constant/app_colors.dart';

import '../../controllers/bottom_nav_controller.dart';
import '../../utils/components/Admin_dashboard_custom_app_bar.dart';

class AdminMainScreen extends StatelessWidget {
  final AdminBottomNavController bottomNavController =
      Get.put(AdminBottomNavController());

  AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const AdminDashboardCustomAppBar(),
        ),
        body: Column(
          children: [
            Flexible(
              child: PageView(
                controller: bottomNavController.pageController,
                onPageChanged: (index) {
                  bottomNavController.changeIndex(index);
                },
                children: bottomNavController.screens,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() {
          return AdminCustomBottomNavigationBar(
            selectedIndex: bottomNavController.selectedIndex.value,
            onTap: (index) {
              bottomNavController.changeIndex(index);
            },
          );
        }),
      ),
    );
  }
}
