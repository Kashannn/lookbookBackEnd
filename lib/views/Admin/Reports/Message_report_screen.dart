import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/views/Admin/Reports/reported_profile_screen.dart';
import '../../../Firebase/firebase_customerEnd_services.dart';
import '../../../Model/Chat/message_model.dart';
import '../../../Model/user/user_model.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/message_report_controller.dart';
import '../../../utils/components/Custom_dialog.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';

class MessageReportScreen extends StatefulWidget {
  final ReportsModel report;

  const MessageReportScreen({super.key, required this.report});

  @override
  State<MessageReportScreen> createState() => _MessageReportScreenState();
}

class _MessageReportScreenState extends State<MessageReportScreen> {
  final MessageReportController _controller =
      Get.put(MessageReportController());

  @override
  void initState() {
    super.initState();
    _controller.fetchReportedUser(widget.report.reported!);
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.report.reportedByUser;
    final reportedMessage = widget.report.messageId;
    final chatRoomId = widget.report.chatroomId;
    print(user?.userId);
    print (widget.report.reportedByUser?.userId);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomAppBar(),
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                if (_controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return SizedBox(
                  width: 430.w,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                'MESSAGE REPORT',
                                style: tSStyleBlack18400,
                              ),
                              SvgPicture.asset(
                                AppImages.line,
                                width: 150.w,
                                height: 15.h,
                                color: AppColors.text1,
                              ),
                            ],
                          ),
                        ),
                        10.ph,
                        _controller.reportedUserModel != null
                            ? buildReportedUserCard()
                            : Text('No user found'),
                        30.ph,
                        buildReporterDetails(user),
                        30.ph,
                        SizedBox(
                          height: 42.h,
                          width: 162.w,
                          child: ElevatedButton(
                            onPressed: _controller.blockUser,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Block'),
                                Icon(
                                  Icons.east,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReportedUserCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 27.0.r,
              backgroundColor: Colors.grey.shade200,
              child: _controller.reportedUserModel!.imageUrl != null &&
                      _controller.reportedUserModel!.imageUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        _controller.reportedUserModel!.imageUrl!,
                        fit: BoxFit.cover,
                        height: 60.h,
                        width: 60.0.w,
                      ),
                    )
                  : Text(
                      getInitials(_controller.reportedUserModel!.fullName!),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
            ),
          ],
        ),
        10.pw,
        Expanded(
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(25.r),
            dashPattern: [6, 3],
            color: Colors.red,
            strokeWidth: 1.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: Color(0xFFDADADA),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _controller.reportedUserModel!.fullName!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        color: Color(0xFF71727A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    buildMessage(
                        widget.report.chatroomId!, widget.report.messageId!),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => ReportProfileScreen(
                                userId:
                                    _controller.reportedUserModel!.userId!));
                          },
                          child: Text(
                            'View Profile',
                            style: iStyleBlack13700.copyWith(
                              color: Color(0xFFE47F46),
                              decoration: TextDecoration.underline,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMessage(String chatRoomId, String messageId) {
    return StreamBuilder<MessageModel>(
      stream: ChatController().getMessage(chatRoomId, messageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('No message found.');
        }

        MessageModel message = snapshot.data!;
        return message.text != ''
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      message.text ?? 'No Text',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6E6E6E),
                      ),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () {
                  Get.to(() => FullScreenImageViewer(imagePath: message.img!));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    message.img!,
                    height: 200.h,
                    width: 200.w,
                    fit: BoxFit.cover,
                  ),
                ),
              );
      },
    );
  }

  Widget buildReporterDetails(UserModel? user) {
    return SizedBox(
      width: 381.w,
      height: 178.h,
      child: InkWell(
        onTap: () {},
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 27.0.r,
                      backgroundColor: Colors.grey.shade200,
                      child:
                          user?.imageUrl != null && user!.imageUrl!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    user!.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: 60.0.w,
                                    height: 60.0.h,
                                  ),
                                )
                              : Text(
                                  getInitials(user?.fullName ?? 'Unknown'),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                    ),
                    10.pw,
                    Text(
                      user?.fullName ?? 'Unknown',
                      style: iStyleBlack13700.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    10.pw,
                    GestureDetector(
                      onTap: () {
                        if (user?.userId != null) {
                          Get.to(
                              () => ReportProfileScreen(userId: user!.userId!));
                        } else {
                          Get.snackbar("Error", "User ID is null.",
                              snackPosition: SnackPosition.TOP);
                        }
                      },
                      child: Text(
                        'View Profile',
                        style: iStyleBlack13700.copyWith(
                          color: Color(0xFFE47F46),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    height: 64.h,
                    width: 340.w,
                    child: Text(
                      widget.report.reason ?? 'No message available',
                      style: iStyleBlack14400.copyWith(
                        color: AppColors.text3,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
