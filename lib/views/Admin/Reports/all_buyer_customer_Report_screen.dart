import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Reports/report_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Model/AddProductModel/product_reported_model.dart';
import '../../../Model/Chat/reports_model.dart';
import '../../../Model/user/user_model.dart';
import '../../../controllers/all_buyer_customer_report_controller.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../Designers/Designer_details_screen.dart';
import 'Message_report_screen.dart';

class AllBuyerCustomerReportScreen extends StatefulWidget {
  const AllBuyerCustomerReportScreen({super.key});

  @override
  State<AllBuyerCustomerReportScreen> createState() =>
      _AllBuyerCustomerReportScreenState();
}

class _AllBuyerCustomerReportScreenState
    extends State<AllBuyerCustomerReportScreen> {
  final AllBuyerCustomerReportController controller = Get.put(
    AllBuyerCustomerReportController(),
  );

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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      'R E P O R T',
                      style: tSStyleBlack18500,
                    ),
                    SvgPicture.asset(
                      AppImages.line,
                      color: AppColors.text1,
                    ),
                  ],
                ),
              ),
              20.ph,
              TextField(
                controller: controller.searchController,
                onChanged: (value) {
                  controller.searchQuery.value = value; // Trigger search
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
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
              20.ph,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(
                  () => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
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
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              'Designer',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: controller.selectedIndex.value == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              'Customer',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: controller.selectedIndex.value == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: controller.selectedIndex.value == 2
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              10.ph,
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    // First Tab (Designer Reports)
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ));
                      } else if (controller
                          .filteredDesignerReportsList.isEmpty) {
                        return Center(
                            child: Text('No reports from designers.'));
                      } else {
                        return ListView.builder(
                          itemCount:
                              controller.filteredDesignerReportsList.length,
                          itemBuilder: (context, index) {
                            final report =
                                controller.filteredDesignerReportsList[index];
                            return ReportCard(report: report);
                          },
                        );
                      }
                    }),

                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ));
                      } else if (controller
                          .filteredCustomerReportsList.isEmpty) {
                        return Center(
                            child: Text('No reports from customers.'));
                      } else {
                        return ListView.builder(
                          itemCount:
                              controller.filteredCustomerReportsList.length,
                          itemBuilder: (context, index) {
                            final report =
                                controller.filteredCustomerReportsList[index];
                            return ReportCard(report: report);
                          },
                        );
                      }
                    }),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: AppColors.secondary,
                        ));
                      } else if (controller.filteredProductReports.isEmpty) {
                        return Center(
                          child: Text('No users have reported products.'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: controller.filteredProductReports.length,
                          itemBuilder: (context, index) {
                            final report =
                                controller.filteredProductReports[index];
                            final user = report
                                .reportedByUser; // Get user from the filtered list
                            final product =
                                report; // The report already contains the product

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: SizedBox(
                                width: double.infinity,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ReportScreen(
                                        productReportedModel: product,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F9FE),
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
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 25.0.r,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: ClipOval(
                                                    child:
                                                        user?.imageUrl !=
                                                                    null &&
                                                                user!.imageUrl!
                                                                    .isNotEmpty
                                                            ? Stack(
                                                                children: [
                                                                  Shimmer
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
                                                                        color: AppColors
                                                                            .secondary
                                                                            .withOpacity(0.5),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // Display the user's image
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        ClipOval(
                                                                      child: Image
                                                                          .network(
                                                                        user.imageUrl!,
                                                                        width:
                                                                            60.0.w,
                                                                        height:
                                                                            60.0.h,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        loadingBuilder: (BuildContext context,
                                                                            Widget
                                                                                child,
                                                                            ImageChunkEvent?
                                                                                loadingProgress) {
                                                                          if (loadingProgress ==
                                                                              null)
                                                                            return child;
                                                                          return Shimmer
                                                                              .fromColors(
                                                                            baseColor:
                                                                                Colors.grey[300]!,
                                                                            highlightColor:
                                                                                Colors.grey[100]!,
                                                                            child:
                                                                                Container(
                                                                              width: 60.0.w,
                                                                              height: 60.0.h,
                                                                              decoration: BoxDecoration(
                                                                                color: AppColors.secondary.withOpacity(0.5),
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Container(
                                                                            width:
                                                                                60.0.w,
                                                                            height:
                                                                                60.0.h,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: AppColors.secondary.withOpacity(0.5),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                user.fullName?.substring(0, 1) ?? '',
                                                                                style: tSStyleBlack18500.copyWith(
                                                                                  color: AppColors.white,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
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
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    user?.fullName?.substring(
                                                                            0,
                                                                            1) ??
                                                                        '',
                                                                    style: tSStyleBlack18500
                                                                        .copyWith(
                                                                      color: AppColors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                                SizedBox(width: 15.w),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${user?.fullName} (${user?.role})',
                                                      style: iStyleBlack13700
                                                          .copyWith(
                                                        color: AppColors.text3,
                                                      ),
                                                    ),
                                                    Text(
                                                      user?.phone ??
                                                          'No phone number',
                                                      style: iStyleBlack15400
                                                          .copyWith(
                                                        color: AppColors.text2,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_outlined,
                                            size: 25.sp,
                                            color: const Color(0xFFE47F46),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    })
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

class ReportCard extends StatelessWidget {
  final ReportsModel report;
  const ReportCard({Key? key, required this.report}) : super(key: key);
  String getInitials(String fullName) {
    List<String> names = fullName.split(" ");
    String initials = "";

    if (names.length > 0 && names[0].isNotEmpty) {
      initials += names[0][0];
    }
    if (names.length > 1 && names[1].isNotEmpty) {
      initials += names[1][0];
    }

    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = report.reportedByUser;

    return user != null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  Get.to(() => MessageReportScreen(
                        report: report,
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25.0.r,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                  child: user.imageUrl != null &&
                                          user.imageUrl!.isNotEmpty
                                      ? Stack(
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 60.0.w,
                                                height: 60.0.h,
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondary
                                                      .withOpacity(0.5),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            // Network Image
                                            Positioned.fill(
                                              child: ClipOval(
                                                child: Image.network(
                                                  user.imageUrl!,
                                                  width: 60.0.w,
                                                  height: 60.0.h,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
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
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      width: 60.0.w,
                                                      height: 60.0.h,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .secondary
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          getInitials(
                                                              user.fullName ??
                                                                  ''),
                                                          style: tSStyleBlack18500
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .white),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          width: 60.0.w,
                                          height: 60.0.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary
                                                .withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              getInitials(user.fullName ?? ''),
                                              style: tSStyleBlack18500.copyWith(
                                                  color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              15.pw,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${user.fullName} (${user.role})',
                                    style: iStyleBlack13700.copyWith(
                                        color: AppColors.text3),
                                  ),
                                  Text(
                                    user.phone ?? 'No phone number',
                                    style: iStyleBlack15400.copyWith(
                                      color: AppColors.text2,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          size: 25.sp,
                          color: const Color(0xFFE47F46),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
