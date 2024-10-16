// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:lookbook/extension/sizebox_extension.dart';
// import '../../controllers/customer_dashboard_controller.dart';
// import '../../utils/components/constant/app_colors.dart';
// import '../../utils/components/constant/app_images.dart';
// import '../../utils/components/constant/app_textstyle.dart';
// import '../../utils/components/custom_search_bar.dart';
// import '../../utils/components/reusable_widget.dart';
//
// class CustomerDashboardScreen extends StatelessWidget {
//   final CustomerDashboardController controller =
//   Get.put(CustomerDashboardController());
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SizedBox(
//           width: 430.w,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               10.ph,
//               SizedBox(
//                 height: 43.h,
//                 width: 385.w,
//                 child: CustomSearchBar2(),
//               ),
//               10.ph,
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Obx(() {
//                         if (controller.eventMap.isEmpty) {
//                           return Center(
//                             child: Text('No products found'),
//                           );
//                         }
//                         return Column(
//                           children: controller.eventMap.entries.map((entry) {
//                             final event = entry.key;
//                             final eventProducts = entry.value;
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 10.h),
//                                   child: SizedBox(
//                                     height: 72.h,
//                                     width: 430.w,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           event.toUpperCase(),
//                                           style: tSStyleBlack18400,
//                                         ),
//                                         SvgPicture.asset(
//                                           AppImages.line,
//                                           color: AppColors.text1,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 GridView.builder(
//                                   padding: EdgeInsets.symmetric(vertical: 10.h),
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     crossAxisSpacing: 10.w,
//                                     mainAxisSpacing: 5.h,
//                                     childAspectRatio: 0.68,
//                                   ),
//                                   itemCount: eventProducts.length,
//                                   itemBuilder: (context, index) {
//                                     final product = eventProducts[index];
//                                     return ProductCard(
//                                       imagePath: product.images?.first ??
//                                           AppImages.photographer,
//                                       title: product.dressTitle ?? 'No Title',
//                                       subtitle: product.category?.join(', ') ??
//                                           'No Category',
//                                       price: '\$${product.price ?? '0'}',
//                                       onTap: () {
//                                         Get.toNamed(
//                                             'CustomerProductDetailScreen',
//                                             arguments: {
//                                               'title': product.dressTitle,
//                                               'price': product.price,
//                                             });
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ],
//                             );
//                           }).toList(),
//                         );
//                       }),
//                       20.ph,
//                       Container(
//                         width: 430.w,
//                         height: 296.h,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 5,
//                               blurRadius: 7,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(right: 50.w),
//                               child: Text(
//                                 'LOOK',
//                                 style: aStyleBlack18600.copyWith(
//                                     color: Colors.white),
//                               ),
//                             ),
//                             Text(
//                               'BOOK',
//                               style: aStyleBlack18600.copyWith(
//                                   color: Colors.white),
//                             ),
//                             30.ph,
//                             SizedBox(
//                               height: 74.h,
//                               width: 323.w,
//                               child: Text(
//                                 'Making a luxurious lifestyle accessible for a generous group of women is our daily drive.',
//                                 style: tSStyleBlack16400.copyWith(
//                                     color: Colors.white),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             SvgPicture.asset(
//                               AppImages.line,
//                               color: AppColors.white,
//                             ),
//                             30.ph,
//                             SvgPicture.asset(
//                               AppImages.signature,
//                               width: 150.w,
//                               height: 45.h,
//                               color: AppColors.white,
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: 430.w,
//                         height: 296.h,
//                         decoration: BoxDecoration(
//                           color: AppColors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.5),
//                               spreadRadius: 5,
//                               blurRadius: 7,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                     onPressed: () {},
//                                     icon: SvgPicture.asset(AppImages.twitter)),
//                                 IconButton(
//                                     onPressed: () {},
//                                     icon:
//                                     SvgPicture.asset(AppImages.instagram)),
//                                 IconButton(
//                                     onPressed: () {},
//                                     icon: SvgPicture.asset(AppImages.youTube)),
//                               ],
//                             ),
//                             SvgPicture.asset(
//                               AppImages.line,
//                               color: AppColors.text1,
//                             ),
//                             Text(
//                               'support@fashionstore',
//                               style: tSStyleBlack18400.copyWith(
//                                   color: AppColors.text1),
//                             ),
//                             Text(
//                               '+12 123 456 7896',
//                               style: tSStyleBlack18400.copyWith(
//                                   color: AppColors.text1),
//                             ),
//                             Text(
//                               '  08:00 - 22:00 - Everyday',
//                               style: tSStyleBlack18400.copyWith(
//                                   color: AppColors.text1),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Text(
//                                   'About',
//                                   style: tSStyleBlack20400.copyWith(
//                                       color: AppColors.black),
//                                 ),
//                                 Text(
//                                   'Contact',
//                                   style: tSStyleBlack20400.copyWith(
//                                       color: AppColors.black),
//                                 ),
//                                 Text(
//                                   'Blog',
//                                   style: tSStyleBlack20400.copyWith(
//                                       color: AppColors.black),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       20.ph,
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
