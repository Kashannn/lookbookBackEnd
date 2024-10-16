import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Model/Chat/chat_room_model.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Firebase/firebase_customerEnd_services.dart';
import '../../../Model/Chat/message_model.dart';
import '../../../controllers/chat_controller.dart';
import '../../../utils/components/constant/app_colors.dart';
import '../../../utils/components/constant/app_images.dart';
import '../../../utils/components/constant/app_textstyle.dart';
import '../../../utils/components/custom_app_bar.dart';
import '../../../utils/components/reusable_widget.dart';

class MessageChatScreen extends StatefulWidget {
  final ChatRoomModel chatroom;
  final UserModel user1;
  final UserModel user2;
  MessageChatScreen(
      {super.key,
      required this.chatroom,
      required this.user1,
      required this.user2});
  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends State<MessageChatScreen> {
  final ChatController controller = ChatController();
  final FirebaseCustomerEndServices customerEndServices =
      FirebaseCustomerEndServices();

  CollectionReference get messagesRef => controller.chatroomsRef
      .doc(widget.chatroom.chatroomId)
      .collection('messages');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(),
              SizedBox(height: 20.h),
              SizedBox(
                height: 72.h,
                width: 430.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'CONVERSATIONS',
                                style: tSStyleBlack18400,
                              ),
                              SvgPicture.asset(
                                AppImages.line,
                                color: AppColors.text1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: StreamBuilder(
                  stream: messagesRef
                      .orderBy('sentOn', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        List<DocumentSnapshot> docs = snapshot.data!.docs;

                        if (docs.isNotEmpty) {
                          return ListView.builder(
                              reverse: true,
                              itemCount: docs.length,
                              padding: EdgeInsets.only(
                                  top: MediaQuery.sizeOf(context).height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                MessageModel message = MessageModel.fromMap(
                                    docs[index].data() as Map<String, dynamic>);
                                bool user =
                                    message.sender == widget.user1.userId;
                                return _buildChatBubble(
                                  text: message.text ?? '',
                                  isSender: user ? true : false,
                                  avatar: user
                                      ? widget.user1.imageUrl!
                                      : widget.user2.imageUrl!,
                                  image: message.img,
                                  isReported: message.isReported!,
                                  name: user
                                      ? widget.user1.fullName!
                                      : widget.user2
                                          .fullName!, // Pass the correct name here
                                );
                              });
                        } else {
                          return const Center(
                            child: Text('Say Hii! 👋',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                ),
              ),
              // Expanded(
              //   child: ListView(
              //     padding: EdgeInsets.symmetric(horizontal: 20.w),
              //     children: [
              //       _buildChatBubble(
              //         text: "Hey Lucas!\nHow's your project going?",
              //         isSender: false,
              //         avatar: 'assets/images/avatar_brooke.png',
              //       ),
              //       _buildChatBubble(
              //         text: "Hi Brooke!",
              //         isSender: true,
              //         avatar: 'assets/images/avatar_lucas.png',
              //       ),
              //       _buildChatBubble(
              //         text: "It's going well. Thanks for asking!",
              //         isSender: true,
              //         avatar: 'assets/images/avatar_lucas.png',
              //       ),
              //       _buildChatBubble(
              //         text: "No worries. Let me know if you need any help 😊",
              //         isSender: false,
              //         avatar: 'assets/images/avatar_brooke.png',
              //       ),
              //       _buildChatBubble(
              //         text: "You're the best!",
              //         isSender: true,
              //         avatar: 'assets/images/avatar_lucas.png',
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildChatBubble({
    required String text,
    required bool isSender,
    required String avatar,
    required String? image,
    required bool isReported,
    required String name, // Add this parameter to pass the name
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender)
            CircleAvatar(
              radius: 22.r,
              backgroundColor: AppColors.secondary,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: avatar.isNotEmpty
                        ? Stack(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 37.5.w,
                                  height: 40.0.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              // Display Network Image
                              Positioned.fill(
                                child: ClipOval(
                                  child: Image.network(
                                    avatar,
                                    fit: BoxFit.cover,
                                    width: 37.5.w,
                                    height: 40.0.h,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 37.5.w,
                                          height: 40.0.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary
                                                .withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 37.5.w,
                                        height: 40.0.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary
                                              .withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            getInitials(
                                                widget.user2.fullName ?? ''),
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
                            width: 37.5.w,
                            height: 40.0.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                getInitials(widget.user2.fullName ?? ''),
                                style: tSStyleBlack18500.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          if (!isSender) SizedBox(width: 10.w),
          text != ''
              ? Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      constraints: BoxConstraints(maxWidth: 250.w),
                      decoration: BoxDecoration(
                        color: isSender
                            ? AppColors.secondary
                            : AppColors.counterColor,
                        borderRadius: BorderRadius.only(
                          topLeft: isSender
                              ? Radius.circular(15.r)
                              : const Radius.circular(0),
                          topRight: isSender
                              ? const Radius.circular(0)
                              : Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),
                          bottomRight: Radius.circular(15.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isSender
                                ? widget.user1.fullName!
                                : widget.user2.fullName!,
                            style: !isSender
                                ? tSStyleBlack12700.copyWith(
                                    color: AppColors.text2)
                                : tSStyleBlack12700.copyWith(
                                    color: Color(0xFFB4DBFF)),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            text,
                            style: isSender
                                ? tSStyleBlack15400.copyWith(
                                    color: AppColors.white)
                                : tSStyleBlack15400,
                          ),
                        ],
                      ),
                    ),
                    if (isReported && !isSender)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Reported',
                          style: tSStyleBlack10400.copyWith(
                              color: AppColors.red, fontSize: 12.sp),
                        ),
                      )
                  ],
                )
              : Column(
                  crossAxisAlignment: isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FullScreenImageViewer(imagePath: image));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          image!,
                          height: 200.h,
                          width: 200.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isReported && !isSender)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Reported',
                          style: tSStyleBlack10400.copyWith(
                              color: AppColors.red, fontSize: 12.sp),
                        ),
                      )
                  ],
                ),
          if (isSender) SizedBox(width: 10.w),
          if (isSender)
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: avatar.isNotEmpty
                    ? Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 37.5.w,
                              height: 40.0.h,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: ClipOval(
                              child: Image.network(
                                avatar,
                                fit: BoxFit.cover,
                                width: 37.5.w,
                                height: 40.0.h,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 37.5.w,
                                      height: 40.0.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary
                                            .withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 37.5.w,
                                    height: 40.0.h,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.secondary.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        getInitials(name),
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
                        width: 37.5.w,
                        height: 40.0.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            getInitials(name), // Pass the name here
                            style: tSStyleBlack18500.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
