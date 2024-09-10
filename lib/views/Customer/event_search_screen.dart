import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_search_bar.dart';
import '../../utils/components/reusedbutton.dart';
import 'filter_event_date_screen.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  _EventSearchScreenState createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  bool isEventSelected = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 150.0.w,
                  child: const Divider(
                    thickness: 3,
                    color: AppColors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 195.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(6.0.r),
                    border: Border.all(
                      color: AppColors.divider2,
                      width: 3.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEventSelected = true;
                          });
                        },
                        child: Container(
                          width: 91.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: isEventSelected
                                ? AppColors.white
                                : AppColors.divider,
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Center(
                            child: Text(
                              'Events',
                              style: oStyleBlack16600.copyWith(
                                color: isEventSelected
                                    ? AppColors.secondary
                                    : AppColors.text6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEventSelected = false;
                          });
                        },
                        child: Container(
                          width: 91.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: !isEventSelected
                                ? AppColors.white
                                : AppColors.divider,
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Center(
                            child: Text(
                              'Date',
                              style: oStyleBlack16600.copyWith(
                                color: !isEventSelected
                                    ? AppColors.secondary
                                    : AppColors.text6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              16.ph,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 390.w,
                    child: CustomSearchBar(),
                  ),
                  20.ph,
                  Container(
                    width: 390.w,
                    height: 350.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9).withOpacity(0.24),
                      borderRadius: BorderRadius.circular(6.0.r),
                      border: Border.all(
                        color: AppColors.divider2,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: isEventSelected
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.ph,
                                Text('SEARCH RESULTS',
                                    style: oStyleBlack16600.copyWith(
                                        color: AppColors.secondary)),
                                10.ph,
                                Text('Search 1 Event Search',
                                    style: oStyleBlack14300.copyWith(
                                        color: AppColors.primaryColor)),
                                10.ph,
                                Text('Search 2 Event Search',
                                    style: oStyleBlack14300.copyWith(
                                        color: AppColors.primaryColor)),
                                10.ph,
                                Text('Search 3 Event Search',
                                    style: oStyleBlack14300.copyWith(
                                        color: AppColors.primaryColor)),
                              ],
                            )
                          : SingleChildScrollView(
                              child: TableCalendar(
                              firstDay: DateTime.utc(2020, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: DateTime.now(),
                              calendarFormat: CalendarFormat.month,
                              selectedDayPredicate: (day) {
                                return isSameDay(DateTime.now(), day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {});
                              },
                              calendarStyle: CalendarStyle(
                                selectedDecoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                // Styling for today
                                todayDecoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                todayTextStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                defaultTextStyle: iStyleBlack13700,
                                weekendTextStyle: iStyleBlack13700,
                                outsideDaysVisible: false,
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                leftChevronIcon: Icon(Icons.chevron_left,
                                    color: Colors.grey),
                                rightChevronIcon: Icon(Icons.chevron_right,
                                    color: Colors.grey),
                              ),
                            )),
                    ),
                  ),
                  20.ph,
                  SizedBox(
                    height: 58.h,
                    child: reusedButton(
                      text: 'FIND RESULTS',
                      ontap: () {
                        Get.to(
                          () => const FilterEventDateScreen(),
                        );
                      },
                      color: AppColors.secondary,
                      icon: Icons.east,
                    ),
                  ),
                  20.ph
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
