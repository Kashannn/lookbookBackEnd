import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../Firebase/firebase_customerEnd_services.dart';
import '../../Model/AddProductModel/product_reported_model.dart';
import '../../Model/Chat/reports_model.dart';
import '../../Model/NotificationModel/notification_model.dart';
import '../../Model/user/user_model.dart';
import '../../Notification/notification.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/customer_report_controller.dart';
import '../../controllers/sign_up_screen_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../Designer/designer_message_chat_screen.dart';
import 'Reports/Message_report_screen.dart';
import 'Reports/report_screen.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});
  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    String getInitials(String name) {
      List<String> nameParts = name.split(' ');
      if (nameParts.length >= 2) {
        return nameParts[0][0] + nameParts[1][0];
      } else if (nameParts.isNotEmpty) {
        return nameParts[0][0];
      }
      return '';
    }

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 26.h),
          child: Column(
            children: [
              Center(
                child: Text(
                  'N O T I F I C A T I O N S',
                  style: tSStyleBlack18500,
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  AppImages.line,
                  width: 150.w,
                  height: 15.h,
                  color: AppColors.text1,
                ),
              ),
              30.ph,
              Expanded(
                child: StreamBuilder<List<NotificationModel>>(
                  stream: NotificationService().fetchNotifications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return Center(
                          child: Text(
                        'NO NOTIFICATIONS TO SHOW',
                        style: tSStyleBlack16400,
                      ));
                    }

                    List<NotificationModel> notifications = snapshot.data!;
                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (BuildContext context, int index) {
                        NotificationModel notificationModel =
                            notifications[index];
                        Color backgroundColor = notificationModel.isRead
                            ? AppColors.white
                            : Color(0xFFF8F9FE);
                        return GestureDetector(
                          onTap: () async {
                            NotificationModel currentNotification =
                                notificationModel;
                            if (currentNotification.notificationType ==
                                'report') {
                              String? reportedBy = currentNotification.senderId;
                              String productId = currentNotification.productId!;
                              print("productId:" + productId);
                              print("reportedBy:" + reportedBy!);

                              try {
                                ProductReportedModel? productReportedModel =
                                    await CustomerReportController()
                                        .getReportByProductIdAndReportedBy(
                                            productId, reportedBy!);
                                await Get.to(() => ReportScreen(
                                      productReportedModel:
                                          ProductReportedModel(
                                        productId:
                                            productReportedModel?.productId ??
                                                '',
                                        reason:
                                            productReportedModel?.reason ?? '',
                                        reportedBy:
                                            productReportedModel?.reportedBy ??
                                                '',
                                        reportedDesigner: productReportedModel
                                                ?.reportedDesigner ??
                                            '',
                                        reportedAt: DateTime.parse(
                                            productReportedModel?.reportedAt
                                                    .toString() ??
                                                DateTime.now().toString()),
                                      ),
                                    ));
                              } catch (e) {
                                print("Error parsing reportedAt date: $e");
                              }
                            } else if (notifications[index].notificationType ==
                                'MessageReport') {
                              ReportsModel reportsModel = await ChatController()
                                  .getReportById(
                                      notifications[index].productId!);
                              UserModel? reportedBy =
                                  await SignUpController().getUserByUserId(
                                reportsModel.reportedBy.toString(),
                              );
                              Get.to(
                                () => MessageReportScreen(
                                  report: ReportsModel(
                                    id: reportsModel.id,
                                    reported: reportsModel.reported,
                                    reportedBy: reportsModel.reportedBy,
                                    messageId: reportsModel.messageId,
                                    chatroomId: reportsModel.chatroomId,
                                    reason: reportsModel.reason,
                                    imageUrl: reportsModel.imageUrl,
                                    date: reportsModel.date,
                                    reportedByUser: reportedBy,
                                  ),
                                ),
                              );
                            }

                            // After returning, mark the notification as read
                            if (!currentNotification.isRead) {
                              currentNotification.isRead =
                                  true; // Update the local state
                              await NotificationService()
                                  .updateNotificationStatus(
                                      currentNotification.id, true);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: FutureBuilder<UserModel?>(
                              future: FirebaseCustomerEndServices()
                                  .fetchUser(notificationModel.senderId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 18.0),
                                    child: Row(
                                      children: [],
                                    ),
                                  );
                                }

                                if (!snapshot.hasData) {
                                  return const Text('No notifications found');
                                }

                                UserModel? user = snapshot.data!;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30.0.r,
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: user.imageUrl != null &&
                                                  user.imageUrl!.isNotEmpty
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
                                                              .withOpacity(0.5),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned.fill(
                                                      child: ClipOval(
                                                        child: Image.network(
                                                          user.imageUrl!,
                                                          fit: BoxFit.cover,
                                                          width: 60.0.w,
                                                          height: 60.0.h,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;
                                                            return Shimmer
                                                                .fromColors(
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
                                                                      user.fullName ??
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
                                                          user.fullName ?? ''),
                                                      style: tSStyleBlack18500
                                                          .copyWith(
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      15.pw,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.fullName!,
                                              style: iStyleBlack13700.copyWith(
                                                color: AppColors.text3,
                                              ),
                                            ),
                                            Text(
                                              notificationModel.message,
                                              style: iStyleBlack13400.copyWith(
                                                color: AppColors.text2,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      if (!notificationModel.isRead)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Text(
                                            'New',
                                            style: TextStyle(
                                              color: Colors.white, // Text color
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
