import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lookbook/Firebase/firebase_customerEnd_services.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/controllers/chat_controller.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/utils/components/custom_search_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../Model/Chat/chat_room_model.dart';
import '../../Model/Chat/message_model.dart';
import '../../controllers/customer_allconversation_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import 'customer_message_chat_screen.dart';

class CustomerAllConversationScreen extends StatefulWidget {
  const CustomerAllConversationScreen({super.key});

  @override
  State<CustomerAllConversationScreen> createState() =>
      _CustomerAllConversationScreenState();
}

class _CustomerAllConversationScreenState
    extends State<CustomerAllConversationScreen> {
  final CustomerAllConversationController controller =
      CustomerAllConversationController();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final ChatController chatController = Get.put(ChatController());
    final FirebaseCustomerEndServices firebaseCustomerEndServices =
        FirebaseCustomerEndServices();
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 72.h,
              width: 430.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'M E S S A G E S',
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
              height: 43.h,
              width: 385.w,
              child: CustomSearchBar3(searchController: searchController),
            ),
            20.ph,
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: controller.fetchDesignersForChat(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'NO USERS TO SHOW',
                        style: tSStyleBlack16400,
                      ),
                    );
                  }

                  List<UserModel> designers = snapshot.data!;
                  if (searchQuery.isNotEmpty) {
                    designers = designers
                        .where((designer) => designer.fullName!
                            .toLowerCase()
                            .contains(searchQuery))
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: designers.length,
                    itemBuilder: (BuildContext context, int index) {
                      UserModel designer = designers[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                        child: InkWell(
                          onTap: () async {
                            ChatRoomModel chatroom =
                                await chatController.createOrGetChatroom(
                                    customerId: currentUserId,
                                    designerId: designer.userId!);
                            // Fetch designer details
                            UserModel? user = await firebaseCustomerEndServices
                                .fetchUser(designer.userId!);
                            // Mark messages as read
                            chatController.markMessagesAsRead(
                              chatController.chatroomsRef
                                  .doc(chatroom.chatroomId)
                                  .collection('messages'),
                              currentUserId,
                            );
                            // Navigate to the chat screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerMessageChatScreen(
                                  chatroom: chatroom,
                                  currentUserId: currentUserId,
                                  otherUserId: designer.userId!,
                                  designer: user!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Designer's Avatar and Name
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: ClipOval(
                                          child: designer.imageUrl != null &&
                                                  designer.imageUrl!.isNotEmpty
                                              ? Image.network(
                                                  designer.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  width: 60.0.w,
                                                  height: 60.0.h,
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
                                                      designer.fullName!
                                                          .substring(0, 2)
                                                          .toUpperCase(),
                                                      style: tSStyleBlack18500
                                                          .copyWith(
                                                        color: AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 15.w),
                                      Text(
                                        designer.fullName!,
                                        style: iStyleBlack13700.copyWith(
                                          color: AppColors.text3,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Unread Messages Count
                                  FutureBuilder<String>(
                                    future: chatController
                                        .createOrGetChatroom(
                                            customerId: currentUserId,
                                            designerId: designer.userId!)
                                        .then(
                                            (chatroom) => chatroom.chatroomId!),
                                    builder: (context, futureSnapshot) {
                                      if (futureSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox();
                                      }
                                      if (futureSnapshot.hasError ||
                                          !futureSnapshot.hasData) {
                                        return SizedBox();
                                      }

                                      String chatroomId = futureSnapshot.data!;

                                      return StreamBuilder<List<MessageModel>>(
                                        stream: chatController
                                            .fetchUnreadMessages(chatroomId),
                                        builder: (context, messageSnapshot) {
                                          if (messageSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox();
                                          }
                                          if (messageSnapshot.hasError) {
                                            return SizedBox(); // Handle error
                                          }

                                          int unreadCount =
                                              messageSnapshot.data?.length ?? 0;

                                          return unreadCount > 0
                                              ? CircleAvatar(
                                                  radius: 15.0.r,
                                                  backgroundColor:
                                                      AppColors.secondary,
                                                  child: Text(
                                                    unreadCount.toString(),
                                                    style: oStyleBlack14300
                                                        .copyWith(
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox();
                                        },
                                      );
                                    },
                                  )
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
            )
          ],
        ),
      ),
    );
  }
}
