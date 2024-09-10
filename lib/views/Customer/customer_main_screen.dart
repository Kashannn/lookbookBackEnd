import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../../utils/components/Customer_dashboard_custom_app_bar.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/Admin_dashboard_custom_app_bar.dart';
import '../../utils/components/customer_custom_bottom_navigation_bar.dart';
import 'QR_Scanner_Screen.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final CustomerBottomNavController bottomNavController =
      Get.put(CustomerBottomNavController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.h),
          child: CustomerDashboardCustomAppBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: bottomNavController.pageController,
                onPageChanged: (index) {
                  bottomNavController
                      .changeIndex(index);
                },
                children: bottomNavController
                    .screens, // Ensure the screens list is correct
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => QRScannerScreen());
          },
          backgroundColor: AppColors.secondary,
          shape: const CircleBorder(),
          child: SvgPicture.asset(AppImages.scanFrame, color: Colors.white),
        ),
        bottomNavigationBar: Obx(() {
          return CustomerCustomBottomNavigationBar(
            selectedIndex: bottomNavController.selectedIndex.value,
            onTap: (index) {
              bottomNavController.changeIndex(index); // Change index on tap
            },
          );
        }),
      ),
    );
  }
}
