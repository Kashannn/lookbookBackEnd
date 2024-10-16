import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/all_blocked_user_controller.dart';
import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/constant/app_colors.dart';

import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';

class AllBlockedUser extends StatefulWidget {
  const AllBlockedUser({super.key});
  @override
  State<AllBlockedUser> createState() => _AllBlockedUserState();
}

class _AllBlockedUserState extends State<AllBlockedUser> {
  final AllBlockedUserController controller =
      Get.put(AllBlockedUserController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
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
                      'B L O C K E D  U S E R S',
                      style: oStyleBlack18400,
                    ),
                    SvgPicture.asset(
                      AppImages.line,
                      color: AppColors.text1,
                    ),
                  ],
                ),
              ),
              10.ph,
              SizedBox(
                child: TextField(
                  controller:
                      controller.searchController, // Ensure this is linked
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FE),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF2F3036),
                      size: 24.sp,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: const Color(0xFF8F9098),
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              20.ph,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(
                  () => Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: TabBar(
                        controller: controller.tabController,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.transparent,
                        labelColor: Color(0xFFE27240),
                        unselectedLabelColor: Color(0xFF6E6E6E),
                        tabs: [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'Designer',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight:
                                      controller.selectedIndex.value == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'Customer',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight:
                                      controller.selectedIndex.value == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              20.ph,
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    StreamBuilder<List<UserModel>>(
                      stream: controller.fetchBlockedDesignersStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final blockedDesigners = snapshot.data ?? [];

                        return ListView.builder(
                          itemCount: blockedDesigners.length,
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemBuilder: (context, index) {
                            var designer = blockedDesigners[index];
                            String getInitials(String name) {
                              List<String> nameParts = name.split(' ');
                              if (nameParts.length >= 2) {
                                return nameParts[0][0] + nameParts[1][0];
                              } else if (nameParts.isNotEmpty) {
                                return nameParts[0][0];
                              }
                              return '';
                            }

                            return Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Material(
                                  elevation: 1,
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Color(0xFFEB5757).withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30.0.r,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: ClipOval(
                                                  child: designer.imageUrl !=
                                                              null &&
                                                          designer.imageUrl!
                                                              .isNotEmpty
                                                      ? Stack(
                                                          children: [
                                                            // Shimmer effect while loading
                                                            Shimmer.fromColors(
                                                              baseColor: Colors
                                                                  .grey[300]!,
                                                              highlightColor:
                                                                  Colors.grey[
                                                                      100]!,
                                                              child: Container(
                                                                width: 60.0.w,
                                                                height: 60.0.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                          0.5),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                            ),
                                                            // Network Image
                                                            Positioned.fill(
                                                              child:
                                                                  Image.network(
                                                                designer
                                                                    .imageUrl!,
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: 60.0.w,
                                                                height: 60.0.h,
                                                                loadingBuilder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child; // Image is loaded
                                                                  } else {
                                                                    // Show shimmer effect while loading
                                                                    return Shimmer
                                                                        .fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey[300]!,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey[100]!,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            60.0.w,
                                                                        height:
                                                                            60.0.h,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: AppColors
                                                                              .secondary
                                                                              .withOpacity(0.5),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  // Show initials if there's an error loading the image
                                                                  return Container(
                                                                    width:
                                                                        60.0.w,
                                                                    height:
                                                                        60.0.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                              0.5),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        getInitials(designer.fullName ??
                                                                            ''),
                                                                        style: tSStyleBlack18500
                                                                            .copyWith(
                                                                          color:
                                                                              AppColors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(
                                                          width: 60.0.w,
                                                          height: 60.0.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .secondary
                                                                .withOpacity(
                                                                    0.5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              getInitials(designer
                                                                      .fullName ??
                                                                  ''),
                                                              style:
                                                                  tSStyleBlack18500
                                                                      .copyWith(
                                                                color: AppColors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),

                                              15.pw, // Space between avatar and text
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    designer.fullName ??
                                                        'No Name',
                                                    style: iStyleBlack13700
                                                        .copyWith(
                                                      color: AppColors.text3,
                                                    ),
                                                  ),
                                                  Text(
                                                    designer.phone ??
                                                        designer.email ??
                                                        'No Contact Info',
                                                    style: iStyleBlack15400
                                                        .copyWith(
                                                      color: AppColors.text2,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 40.h,
                                            width: 117.w,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showCustomDialogToBlock(context,
                                                    title:
                                                        'Sure you want to Unblock?',
                                                    message:
                                                        'Are you sure you want to Unblock this user?',
                                                    onConfirm: () {
                                                  controller.unblockDesigner(
                                                      designer);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.red,
                                                foregroundColor:
                                                    AppColors.white,
                                              ),
                                              child: Text('Unblock',
                                                  style: tSStyleBlack14400
                                                      .copyWith(
                                                          color:
                                                              AppColors.white)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                    StreamBuilder<List<UserModel>>(
                      stream: controller.fetchBlockedCustomersStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        final blockedCustomers = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: blockedCustomers.length,
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemBuilder: (context, index) {
                            String getInitials(String name) {
                              List<String> nameParts = name.split(' ');
                              if (nameParts.length >= 2) {
                                return nameParts[0][0] + nameParts[1][0];
                              } else if (nameParts.isNotEmpty) {
                                return nameParts[0][0];
                              }
                              return '';
                            }

                            var customer = blockedCustomers[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Material(
                                elevation: 1,
                                borderRadius: BorderRadius.circular(10.r),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEB5757).withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 30.0.r,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: ClipOval(
                                                child: customer.imageUrl !=
                                                            null &&
                                                        customer.imageUrl!
                                                            .isNotEmpty
                                                    ? Stack(
                                                        children: [
                                                          // Shimmer effect while loading
                                                          Shimmer.fromColors(
                                                            baseColor: Colors
                                                                .grey[300]!,
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100]!,
                                                            child: Container(
                                                              width: 60.0.w,
                                                              height: 60.0.h,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.grey,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                          // Network Image
                                                          Image.network(
                                                            customer.imageUrl!,
                                                            fit: BoxFit.cover,
                                                            width: 60.0.w,
                                                            height: 60.0.h,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child; // Image is loaded
                                                              } else {
                                                                return Shimmer
                                                                    .fromColors(
                                                                  baseColor:
                                                                      Colors.grey[
                                                                          300]!,
                                                                  highlightColor:
                                                                      Colors.grey[
                                                                          100]!,
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        60.0.w,
                                                                    height:
                                                                        60.0.h,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .grey,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              // Show initials if there's an error loading the image
                                                              return Container(
                                                                width: 60.0.w,
                                                                height: 60.0.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                          0.5),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    getInitials(
                                                                        customer.fullName ??
                                                                            ''),
                                                                    style: tSStyleBlack18500
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        width: 60.0.w,
                                                        height: 60.0.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(0.5),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            getInitials(customer
                                                                    .fullName ??
                                                                ''),
                                                            style:
                                                                tSStyleBlack18500
                                                                    .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                            15.pw,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  customer.fullName ??
                                                      'No Name',
                                                  style:
                                                      iStyleBlack13700.copyWith(
                                                    color: AppColors.text3,
                                                  ),
                                                ),
                                                Text(
                                                  customer.phone ??
                                                      customer.email ??
                                                      'No Contact Info',
                                                  style:
                                                      iStyleBlack15400.copyWith(
                                                    color: AppColors.text2,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 40.h,
                                          width: 117.w,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showCustomDialogToBlock(context,
                                                  title:
                                                      'Sure you want to Unblock?',
                                                  message:
                                                      'Are you sure you want to Unblock this user?',
                                                  onConfirm: () {
                                                controller
                                                    .unblockCustomer(customer);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.red,
                                              foregroundColor: AppColors.white,
                                            ),
                                            child: Text('Unblock',
                                                style:
                                                    tSStyleBlack14400.copyWith(
                                                        color:
                                                            AppColors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
