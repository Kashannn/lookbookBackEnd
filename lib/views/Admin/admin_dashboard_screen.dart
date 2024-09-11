import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Reports/all_buyer_customer_screen.dart';
import '../../utils/components/admin_custom_card.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import 'Conversations/admin_allconversation_screen.dart';
import 'Customers/all_customers_screen.dart';
import 'Designers/all_Designers_screen.dart';
import 'Products/admin_product_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(430, 912));
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ADMIN DASHBOARD',
                    style: tSStyleBlack18400,
                  ),
                  10.ph,
                  SvgPicture.asset(
                    AppImages.line,
                    color: AppColors.text1,
                  ),
                ],
              ),
            ),
            20.ph,
            Expanded(
                child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 584.h,
                  width: 336.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCard(
                        logoPath: AppImages.designersLogo,
                        title: 'Designers',
                        onPressed: () {
                          Get.to(() => const AllUserScreen());
                        },
                      ),
                      CustomCard(
                        logoPath: AppImages.customersLogo,
                        title: 'Customers',
                        onPressed: () {
                          Get.to(() => const AllCustomersScreen());
                        },
                      ),
                      CustomCard(
                        logoPath: AppImages.productsLogo,
                        title: 'Products',
                        onPressed: () {
                          Get.to(() => const AdminProductScreen());
                        },
                      ),
                      CustomCard(
                        logoPath: AppImages.reportsLogo,
                        title: 'Reports',
                        onPressed: () {
                          Get.to(() => const AllBuyerCustomerScreen());
                        },
                      ),
                      CustomCard(
                        logoPath: AppImages.conversationsLogo,
                        title: 'Conversations',
                        onPressed: () {
                          Get.to(() => const AdminAllConversationScreen());
                        },
                      ),
                      20.ph,
                    ],
                  ),
                )
              ]),
            ))
          ],
        ),
      ),
    );
  }
}
