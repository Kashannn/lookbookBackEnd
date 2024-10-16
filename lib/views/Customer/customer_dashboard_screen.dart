import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Customer/customer_product_detail_screen.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import '../../Notification/notification.dart';
import '../../controllers/customer_dashboard_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_search_bar.dart';
import '../../utils/components/reusable_widget.dart';

class CustomerDashboardScreen extends StatefulWidget {
  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final CustomerDashboardController controller =
      Get.put(CustomerDashboardController());
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
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              10.ph,
              SizedBox(
                height: 43.h,
                width: 385.w,
                child: CustomSearchBar2(
                  controller: controller,
                ),
              ),
              40.ph,
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    if (controller.filteredProducts.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('NO PRODUCTS TO SHOW', style: tSStyleBlack16400),
                          SizedBox(height: 30),
                          Icon(Icons.add_shopping_cart_outlined, size: 35),
                        ],
                      );
                    } else {
                      // Grouping products by event
                      Map<String, List<AddProductModel>> groupedProducts = {};
                      for (var product in controller.filteredProducts) {
                        final event =
                            product.event?.toLowerCase() ?? 'no event';
                        if (!groupedProducts.containsKey(event)) {
                          groupedProducts[event] = [];
                        }
                        groupedProducts[event]!.add(product);
                      }

                      // Display events and their products
                      return Column(
                        children: groupedProducts.entries.map((entry) {
                          String event = entry.key;
                          List<AddProductModel> products = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 72.h,
                                width: 430.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      event.toUpperCase(),
                                      style: tSStyleBlack18400,
                                    ),
                                    SvgPicture.asset(
                                      AppImages.line,
                                      color: AppColors.text1,
                                    ),
                                  ],
                                ),
                              ),
                              ...products.map((product) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 16.w),
                                  child: ProductCard(
                                    imagePath: product.images?.first ??
                                        AppImages.photographer,
                                    title: product.dressTitle ?? 'No Title',
                                    subtitle: product.category?.join(', ') ??
                                        'No Category',
                                    price: '\$${product.price ?? '0'}',
                                    onTap: () {
                                      Get.to(CustomerProductDetailScreen(),
                                          arguments: product);
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
