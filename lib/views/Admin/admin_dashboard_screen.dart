import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Reports/all_buyer_customer_Report_screen.dart';
import '../../Notification/notification.dart';
import '../../utils/components/admin_custom_card.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import 'Blocked_User/all_bloacked_user.dart';
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
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.firebaseInit(context);
    notificationService.isTokenRefresh();
    notificationService.requestNotificationPermission();
    notificationService.getToken().then((value) {
      print('Token: $value');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Received notification: ${message.notification?.title}, ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.notification?.title}');
    });
  }

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
            20.ph,
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
                  height: 700.h,
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
                          Get.to(() => const AllBuyerCustomerReportScreen());
                        },
                      ),
                      CustomCard(
                        logoPath: AppImages.conversationsLogo,
                        title: 'Conversations',
                        onPressed: () {
                          Get.to(() => AdminAllConversationScreen());
                        },
                      ),
                      CustomCard(
                        logoPath: AppImages.blockIcon,
                        title: 'Blocked Users',
                        onPressed: () {
                          Get.to(() => const AllBlockedUser());
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
