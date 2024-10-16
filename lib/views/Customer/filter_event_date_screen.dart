import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import '../../Model/AddProductModel/add_product_model.dart';
import '../../controllers/customer_dashboard_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/custom_search_bar.dart';
import '../../utils/components/reusable_widget.dart';

class FilterEventDateScreen extends StatefulWidget {
  const FilterEventDateScreen({super.key});
  @override
  State<FilterEventDateScreen> createState() => _FilterEventDateScreenState();
}

class _FilterEventDateScreenState extends State<FilterEventDateScreen> {
  String? selectedEvent;
  DateTime? selectedDate;
  final CustomerDashboardController controller =
      Get.put(CustomerDashboardController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    selectedEvent = args['event'];
    selectedDate = args['date'];
    controller.filterProductsByEvent(selectedEvent, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: CustomAppBar(),
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: 430.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.ph,
                    SizedBox(
                      height: 43.h,
                      width: 385.w,
                      child: CustomSearchBar3(
                          searchController: controller.searchController),
                    ),
                    20.ph,
                    Text('FILTER BY EVENT',
                        style: oStyleBlack15500.copyWith(
                            color: AppColors.secondary)),
                    10.ph,
                    // if (selectedEvent != null)
                    //   Text(
                    //     'Selected Event: $selectedEvent',
                    //     style: oStyleBlack15500.copyWith(
                    //         color: AppColors.primaryColor),
                    //   ),
                    // if (selectedDate != null)
                    //   Text(
                    //     'Selected Date: ${selectedDate.toString().substring(0, 10)}',
                    //     style: oStyleBlack15500.copyWith(
                    //         color: AppColors.primaryColor),
                    //   ),
                    // 10.ph,
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() {
                      if (controller.filteredProducts.isEmpty) {
                        return Center(
                          child: Text('No products found'),
                        );
                      }
                      Map<String, List<AddProductModel>> groupedProducts =
                          groupProductsByEvent(controller.filteredProducts);

                      return Column(
                        children: groupedProducts.entries.map((entry) {
                          final event = entry.key;
                          final eventProducts = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Text(
                                      event.toUpperCase(),
                                      style: tSStyleBlack18400,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    AppImages.line,
                                    color: AppColors.text1,
                                  ),
                                ],
                              ),
                              GridView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.w,
                                  mainAxisSpacing: 5.h,
                                  childAspectRatio: 0.68,
                                ),
                                itemCount: eventProducts.length,
                                itemBuilder: (context, index) {
                                  final product = eventProducts[index];
                                  return ProductCard(
                                    imagePath: product.images?.first ??
                                        AppImages.photographer,
                                    title: product.dressTitle ?? 'No Title',
                                    subtitle: product.category?.join(', ') ??
                                        'No Category',
                                    price: '\$${product.price ?? '0'}',
                                    onTap: () {
                                      Get.toNamed('CustomerProductDetailScreen',
                                          arguments: product);
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }),
                    20.ph,
                    Container(
                      width: 430.w,
                      height: 296.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 50.w),
                            child: Text(
                              'LOOK',
                              style: aStyleBlack18600.copyWith(
                                  color: Colors.white),
                            ),
                          ),
                          Text(
                            'BOOK',
                            style:
                                aStyleBlack18600.copyWith(color: Colors.white),
                          ),
                          30.ph,
                          SizedBox(
                            height: 74.h,
                            width: 323.w,
                            child: Text(
                              'Making a luxurious lifestyle accessible for a generous group of women is our daily drive.',
                              style: tSStyleBlack16400.copyWith(
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SvgPicture.asset(
                            AppImages.line,
                            color: AppColors.white,
                          ),
                          30.ph,
                          SvgPicture.asset(
                            AppImages.signature,
                            width: 150.w,
                            height: 45.h,
                            color: AppColors.white,
                          )
                        ],
                      ),
                    ),
                    30.ph,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<AddProductModel>> groupProductsByEvent(
      List<AddProductModel> products) {
    Map<String, List<AddProductModel>> groupedProducts = {};

    for (var product in products) {
      String event = product.event?.toLowerCase() ?? 'No Event';

      if (!groupedProducts.containsKey(event)) {
        groupedProducts[event] = [];
      }
      groupedProducts[event]!.add(product);
    }

    return groupedProducts;
  }
}
