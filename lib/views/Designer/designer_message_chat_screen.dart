import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lookbook/Firebase/firebase_customerEnd_services.dart';
import 'package:lookbook/Model/Chat/message_model.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';
import 'package:lookbook/Model/user/user_model.dart';
import 'package:lookbook/extension/sizebox_extension.dart';
import 'package:lookbook/main.dart';
import 'package:shimmer/shimmer.dart';

import '../../Model/Chat/chat_room_model.dart';
import '../../Notification/notification.dart';
import '../../controllers/chat_controller.dart';
import '../../utils/components/constant/app_colors.dart';
import '../../utils/components/constant/app_images.dart';
import '../../utils/components/constant/app_textstyle.dart';
import '../../utils/components/custom_app_bar.dart';
import '../../utils/components/reusable_widget.dart';

class DesignerMessageChatScreen extends StatefulWidget {
  final ChatRoomModel chatroom;
  final String currentUserId;
  final String otherUserId;
  final UserModel user;
  DesignerMessageChatScreen(
      {super.key,
      required this.chatroom,
      required this.currentUserId,
      required this.otherUserId,
      required this.user});

  @override
  State<DesignerMessageChatScreen> createState() =>
      _DesignerMessageChatScreenState();
}

class _DesignerMessageChatScreenState extends State<DesignerMessageChatScreen> {
  final _messageController = TextEditingController();
  final ChatController controller = ChatController();
  final FirebaseCustomerEndServices customerEndServices =
      FirebaseCustomerEndServices();
  bool _showEmoji = false, _isUploading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference get messagesRef => controller.chatroomsRef
      .doc(widget.chatroom.chatroomId)
      .collection('messages');

  void sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;
    String notificationMessage = text.isNotEmpty ? text : "has messaged you";
    _messageController.clear();

    MessageModel message = MessageModel(
      id: '',
      text: text,
      sender: widget.currentUserId,
      receiver: widget.otherUserId,
      sentOn: DateTime.now(),
      isRead: false,
      isReported: false,
    );

    // Add the message to Firestore and get the document reference
    DocumentReference docRef = await messagesRef.add(message.toMap());

    // Update the message id with the documentId generated by Firestore
    await docRef.update({'id': docRef.id});

    // Update the last message in the chatroom
    await controller.chatroomsRef.doc(widget.chatroom.chatroomId).update({
      'lastmessage': text,
      'sentOn': Timestamp.fromDate(message.sentOn!),
    });

    UserModel? userModel =
        await customerEndServices.fetchUser(widget.otherUserId);
    UserModel? currentUserModel =
        await customerEndServices.fetchUser(widget.currentUserId);

    // Send the notification with the actual message or a default message
    NotificationService().chatSendPushNotification(
      currentUserModel!.fullName ?? '',
      userModel!.deviceToken!,
      notificationMessage, // Use the actual message or "has messaged you"
      widget.otherUserId,
      "chat",
      widget.chatroom.chatroomId,
      null,
    );

    print("Notification Sent!!!");
  }

  Future<void> sendImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Upload the image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('chat_images').child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(pickedFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Create message object with image URL (without id initially)
      MessageModel message = MessageModel(
        id: '', // Will update this later with Firestore documentId
        img: downloadUrl,
        sender: widget.currentUserId,
        receiver: widget.otherUserId,
        sentOn: DateTime.now(),
        isRead: false,
      );

      // Add message to Firestore and get document reference
      DocumentReference docRef = await messagesRef.add(message.toMap());

      // Update the message id with the documentId generated by Firestore
      await docRef.update({'id': docRef.id});

      // Update the last message in the chatroom
      await controller.chatroomsRef.doc(widget.chatroom.chatroomId).update({
        'lastmessage':
            'Image', // Set 'Image' as the last message for the chat room
        'sentOn': Timestamp.fromDate(message.sentOn!),
      });
      UserModel? userModel =
          await customerEndServices.fetchUser(widget.otherUserId);
      UserModel? currentUserModel =
          await customerEndServices.fetchUser(widget.currentUserId);
      NotificationService().chatSendPushNotification(
        currentUserModel!.fullName ?? '',
        userModel!.deviceToken!,
        "sent you an image",
        widget.otherUserId,
        "chat",
        widget.chatroom.chatroomId,
        null,
      );
      print("Notification Sent!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = ChatController();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(),
            SizedBox(height: 20.h),
            SizedBox(
              height: 72.h,
              //width: 430.w,
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
                              'MESSAGES',
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
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25.0.r,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: widget.user.imageUrl != null &&
                              widget.user.imageUrl!.isNotEmpty
                          ? Stack(
                              children: [
                                // Shimmer effect while the image is loading
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 60.0.w,
                                    height: 60.0.h,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.secondary.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                // Display Network Image
                                Positioned.fill(
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.user.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: 60.0.w,
                                      height: 60.0.h,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Shimmer.fromColors(
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
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
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
                                                  widget.user.fullName ?? ''),
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
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  getInitials(widget.user.fullName ?? ''),
                                  style: tSStyleBlack18500.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text(widget.user.fullName! ?? '',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Divider(),
            SizedBox(height: 5.h),
            Expanded(
              child: StreamBuilder(
                stream:
                    messagesRef.orderBy('sentOn', descending: true).snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();

                    //if some or all data is loaded then show it
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
                              bool isMe =
                                  message.sender == widget.currentUserId;
                              return _buildChatBubble(
                                  text: message.text ?? '',
                                  isSender: isMe ? true : false,
                                  avatar: widget.user.imageUrl,
                                  image: message.img,
                                  isReported: message.isReported!,
                                  reportsModel: ReportsModel(
                                      reportedBy: widget.currentUserId,
                                      reported: message.sender,
                                      messageId: message.id,
                                      chatroomId: widget.chatroom.chatroomId,
                                      imageUrl: message.img ?? ''));
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

            //progress indicator for showing uploading
            if (_isUploading)
              const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(strokeWidth: 2))),

            //chat input filed
            _chatInput(),

            //show emojis on keyboard emoji button click & vice versa
            if (_showEmoji)
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .35,
                child: EmojiPicker(
                  textEditingController: _messageController,
                  config: const Config(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble({
    required String text,
    required bool isSender,
    required String? avatar,
    required String? image,
    required ReportsModel reportsModel,
    required bool isReported,
  }) {
    return GestureDetector(
      onLongPressStart: (details) {
        showCustomPopupMenu(context, details.globalPosition, reportsModel);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSender) SizedBox(width: 20.w),
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
                            if (!isSender)
                              Text(
                                widget.user.fullName!,
                                style: tSStyleBlack12700.copyWith(
                                    color: AppColors.text2),
                              ),
                            if (!isSender)
                              SizedBox(
                                height: 3.h,
                              ),
                            Text(
                              text,
                              style: isSender
                                  ? tSStyleBlack15400.copyWith(
                                      color: AppColors.white)
                                  : tSStyleBlack15400,
                            )
                          ],
                        ),
                      ),
                      isReported == true && !isSender
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Reported',
                                style: tSStyleBlack10400.copyWith(
                                    color: AppColors.red, fontSize: 12.sp),
                              ),
                            )
                          : SizedBox.shrink()
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
                          borderRadius: BorderRadius.circular(
                              10), // Adjust the radius as needed
                          child: Image.network(
                            image!,
                            height: 200.h,
                            width: 200.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      isReported == true && !isSender
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Reported',
                                style: tSStyleBlack10400.copyWith(
                                    color: AppColors.red, fontSize: 12.sp),
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
            if (isSender) SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin:
                      EdgeInsets.only(bottom: 10.5.h, left: 20.w, right: 20.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 30.5.h,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            sendImage(ImageSource.camera);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 30.5.h,
                                backgroundColor: Colors.pink,
                                child: const Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                              ),
                              5.h.ph,
                              Text(
                                "Camera",
                              ),
                            ],
                          ),
                        ),
                        30.w.pw,
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            sendImage(ImageSource.gallery);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 30.5.h,
                                backgroundColor: Colors.purple,
                                child: const Icon(
                                  Icons.photo,
                                  color: Colors.white,
                                ),
                              ),
                              5.h.ph,
                              Text(
                                "Gallery",
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: AppColors.secondary,
            ),
          ),
          //adding some space
          SizedBox(width: 10.w),
          //input field & buttons

          Expanded(
            child: Card(
              color: AppColors.counterColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(55))),
              child: Row(
                children: [
                  //emoji button
                  15.w.pw,
                  Expanded(
                      child: TextField(
                    controller: _messageController,
                    keyboardType: TextInputType.multiline,
                    style: tSStyleBlack15400,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                            color: Color(0xFF8F9098),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter'),
                        border: InputBorder.none),
                  )),
                  10.w.pw,
                  MaterialButton(
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        sendMessage();
                        //_messageController.text = '';
                      }
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 5, left: 10),
                    shape: const CircleBorder(),
                    color: AppColors.secondary,
                    child: Transform.rotate(
                        angle: 150,
                        child: Center(
                            child: Icon(Icons.send,
                                color: Colors.white, size: 20))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
