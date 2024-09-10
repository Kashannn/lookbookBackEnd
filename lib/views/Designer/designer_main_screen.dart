import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_nav_controller.dart';
import '../../utils/components/Designer_dashboard_custom_app_bar.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/Admin_dashboard_custom_app_bar.dart';
import '../../utils/components/designer_bottom_navigation_bar.dart';

class DesignerMainScreen extends StatefulWidget {
  const DesignerMainScreen({super.key});

  @override
  State<DesignerMainScreen> createState() => _DesignerMainScreenState();
}

class _DesignerMainScreenState extends State<DesignerMainScreen> {
  final DesignerBottomNavController bottomNavController =
      Get.put(DesignerBottomNavController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const DesignerDashboardCustomAppBar(),
            Expanded(
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
          return DesignerBottomNavigationBar(
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
