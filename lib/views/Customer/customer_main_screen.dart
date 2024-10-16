import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lookbook/Firebase/firebase_customerEnd_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/utils/components/constant/app_images.dart';
import 'package:lookbook/views/Customer/customer_product_detail_screen.dart';
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
  FirebaseCustomerEndServices _services = FirebaseCustomerEndServices();

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
                  bottomNavController.changeIndex(index);
                },
                children: bottomNavController.screens,
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _services.requestCameraPermission();
          },
          backgroundColor: AppColors.secondary,
          shape: const CircleBorder(),
          child: SvgPicture.asset(AppImages.scanFrame, color: Colors.white),
        ),
        bottomNavigationBar: Obx(() {
          return CustomerCustomBottomNavigationBar(
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
