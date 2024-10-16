import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/customer_dashboard_controller.dart';
import '../../views/Customer/event_search_screen.dart';
import 'constant/app_images.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
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
    );
  }
}

class CustomSearchBar3 extends StatelessWidget {
  final TextEditingController searchController;

  CustomSearchBar3({Key? key, required this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h),
          filled: true,
          fillColor: const Color(0xFFD9D9D9).withOpacity(0.24),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black.withOpacity(0.50),
            size: 24.sp,
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: const Color(0xFF8F9098),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class CustomSearchBar2 extends StatelessWidget {
  final CustomerDashboardController controller;
  CustomSearchBar2({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h),
          filled: true,
          fillColor: const Color(0xFFD9D9D9).withOpacity(0.24),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black.withOpacity(0.50),
            size: 24.sp,
          ),
          hintText: 'Search by Title',
          hintStyle: TextStyle(
            color: const Color(0xFF8F9098),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.7,
                      minChildSize: 0.7,
                      maxChildSize: 0.7,
                      builder: (_, controller) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.w, vertical: 0.h),
                          child: EventSearchScreen(),
                        );
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  AppImages.searchMenu,
                  height: 15.h,
                  width: 15.w,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
