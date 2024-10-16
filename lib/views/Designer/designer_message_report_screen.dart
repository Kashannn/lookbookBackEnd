import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/controllers/chat_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/constant/snackbar.dart';

import '../../Firebase/firebase_customerEnd_services.dart';
import '../../Model/Chat/message_model.dart';
import '../../utils/components/Custom_dialog.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';
import '../../utils/components/reusedbutton.dart';

class DesignerMessageReportScreen extends StatefulWidget {
  final ReportsModel reportsModel;
  DesignerMessageReportScreen({
    super.key,
    required this.reportsModel,
  });

  @override
  State<DesignerMessageReportScreen> createState() =>
      _DesignerMessageReportScreenState();
}

class _DesignerMessageReportScreenState
    extends State<DesignerMessageReportScreen> {
  TextEditingController reasonController = TextEditingController();
  ChatController chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const CustomAppBar(),
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'R E P O R T',
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Container(
                          height: 40.h,
                          width: 90.w,
                          decoration: BoxDecoration(
                              color: AppColors.counterColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r),
                              )),
                          child: Center(
                            child: Text(
                              'Report',
                              style: tSStyleBlack14400.copyWith(
                                  color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 260.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                          color: Color(0xFFDADADA),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<UserModel?>(
                                future: FirebaseCustomerEndServices()
                                    .fetchUser(widget.reportsModel.reported!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Show loading indicator
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData) {
                                    return Text('No message found.');
                                  }

                                  UserModel user = snapshot.data!;
                                  return Text(
                                    user.fullName! ?? '',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                      color: Color(0xFF71727A),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 2.h),
                              buildMessage(widget.reportsModel.chatroomId!,
                                  widget.reportsModel.messageId!)
                            ],
                          ),
                        ),
                      ),
                      30.ph,
                      Container(
                        // height: 155.h,
                        decoration: BoxDecoration(
                          color: AppColors.counterColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Column(
                            children: [
                              TextField(
                                minLines: 1,
                                maxLines: null,
                                controller: reasonController,
                                decoration: InputDecoration(
                                  hintText: 'Type Reason',
                                  hintStyle: tSStyleBlack14600.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      50.ph,
                      SizedBox(
                        width: 177.w,
                        height: 42.h,
                        child: reusedButton(
                          text: 'REPORT',
                          ontap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Container(
                                    // height: 147.h,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.w, vertical: 15.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: CircleAvatar(
                                                    radius: 15.r,
                                                    backgroundColor:
                                                        Color(0xFFE5E5E5),
                                                    child: Icon(Icons.close,
                                                        color: AppColors.text6,
                                                        size: 15.sp)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Sure you want to report?',
                                                style: TextStyle(
                                                  color: AppColors.text7,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'Inter',
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        Center(
                                          child: Text(
                                              'Are you sure you want to report this?',
                                              style: TextStyle(
                                                color: AppColors.text7
                                                    .withOpacity(0.7),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Inter',
                                              )),
                                        ),
                                        SizedBox(height: 15.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          child: SizedBox(
                                            height: 40.h,
                                            width: 300.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      chatController
                                                          .reportMessage(
                                                              widget
                                                                  .reportsModel,
                                                              reasonController);
                                                      Get.back();
                                                      Navigator.of(context)
                                                          .pop();
                                                      CustomSnackBars.instance
                                                          .showSuccessSnackbar(
                                                              title: 'Success',
                                                              message:
                                                                  'Message reported successfully!');
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          color: AppColors.red,
                          icon: Icons.east,
                        ),
                      ),
                      10.ph,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the radius as needed
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
}
