import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/all_customer_controller.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import 'customer_detail_screen.dart';

class AllCustomersScreen extends StatefulWidget {
  const AllCustomersScreen({super.key});

  @override
  State<AllCustomersScreen> createState() => _AllCustomersScreenState();
}

class _AllCustomersScreenState extends State<AllCustomersScreen> {
  @override
  Widget build(BuildContext context) {
    final AllCustomerController controller = Get.put(AllCustomerController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
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
                    'C U S T O M E R S',
                    style: tSStyleBlack18500,
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
              height: 43.h,
              width: 385.w,
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FE),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF2F3036),
                    size: 24.sp,
                  ),
                  hintText: 'Search Customers',
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
            10.ph,
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ));
                }
                if (controller.filteredCustomerList.isEmpty) {
                  return const Center(child: Text('No Customers found.'));
                }
                return ListView.builder(
                  itemCount: controller.filteredCustomerList.length,
                  itemBuilder: (context, index) {
                    final customer = controller.filteredCustomerList[index];
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => CustomerDetailScreen(
                                  customer: customer,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25.0.r,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: customer.imageUrl != null &&
                                                    customer
                                                        .imageUrl!.isNotEmpty
                                                ? Stack(
                                                    children: [
                                                      Shimmer.fromColors(
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
                                                                .withOpacity(
                                                                    0.5),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                      ),
                                                      // Network Image
                                                      Positioned.fill(
                                                        child: ClipOval(
                                                          child: Image.network(
                                                            customer.imageUrl!,
                                                            width: 60.0.w,
                                                            height: 60.0.h,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
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
                                                                    Colors.grey[
                                                                        300]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  width: 60.0.w,
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
                                                                ),
                                                              );
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
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
                                                        getInitials(
                                                            customer.fullName ??
                                                                ''),
                                                        style: tSStyleBlack18500
                                                            .copyWith(
                                                          color:
                                                              AppColors.white,
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
                                              customer.fullName ?? 'No Name',
                                              style: iStyleBlack13700.copyWith(
                                                color: AppColors.text3,
                                              ),
                                            ),
                                            Text(
                                              customer.phone ??
                                                  'No phone number',
                                              style: iStyleBlack15400.copyWith(
                                                color: AppColors.text2,
                                                decoration:
                                                    TextDecoration.underline,
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
