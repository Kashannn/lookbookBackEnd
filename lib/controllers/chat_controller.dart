import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lookbook/Model/Chat/reports_model.dart';

import '../Model/Chat/chat_room_model.dart';
import '../Model/Chat/message_model.dart';
import '../Model/user/user_model.dart';
import '../Notification/notification.dart';

class ChatController extends GetxController {
  var unreadMessageCount = 0.obs;
  var unreadMessageCountCustomer = 0.obs;

  static FirebaseAuth get auth => FirebaseAuth.instance;
  var designersList = <UserModel>[].obs;
  var filteredDesignersList = <UserModel>[].obs;
  var customersList = <UserModel>[].obs;
  var filteredCustomersList = <UserModel>[].obs;
  TextEditingController searchController = TextEditingController();
  var isLoading = true.obs;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChatRoomModel? chatroom;
  static User get user => auth.currentUser!;
  String get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    filterDesigners(searchController.text);
    filterCustomers(searchController.text);
  }

  void filterDesigners(String query) {
    if (query.isEmpty) {
      filteredDesignersList.assignAll(designersList);
    } else {
      filteredDesignersList.assignAll(designersList.where((designer) {
        return designer.fullName?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList());
    }
  }

  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomersList.assignAll(customersList);
    } else {
      filteredCustomersList.assignAll(customersList.where((customer) {
        return customer.fullName?.toLowerCase().contains(query.toLowerCase()) ??
            false;
      }).toList());
    }
  }

  CollectionReference get chatroomsRef => _firestore.collection('chatrooms');

  String generateChatroomId(String customerId, String designerId) {
    List<String> ids = [customerId, designerId]..sort();
    return ids.join('_');
  }

  // Function to create or retrieve an existing chatroom
  Future<ChatRoomModel> createOrGetChatroom({
    required String customerId,
    required String designerId,
  }) async {
    String chatroomId = generateChatroomId(customerId, designerId);

    DocumentReference chatroomDoc = chatroomsRef.doc(chatroomId);

    DocumentSnapshot docSnapshot = await chatroomDoc.get();

    if (docSnapshot.exists) {
      // Chatroom already exists
      return ChatRoomModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      // Create a new chatroom
      ChatRoomModel chatroom = ChatRoomModel(
        chatroomId: chatroomId,
        participants: {
          customerId: true,
          designerId: true,
        },
        lastMessage: '',
      );

      await chatroomDoc.set(chatroom.toMap());

      return chatroom;
    }
  }

  Future<void> markMessagesAsRead(
      CollectionReference reference, String userId) async {
    QuerySnapshot unreadMessages = await reference
        .where('receiver', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    // Mark messages as read
    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }
    fetchTotalUnreadMessages(userId).listen((count) {
      unreadMessageCount.value = count;
    });
  }

  Future<void> markMessagesAsReadCustomer(
      CollectionReference reference, String userId) async {
    QuerySnapshot unreadMessages = await reference
        .where('receiver', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    // Mark messages as read
    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }

    // Fetch updated unread message count after marking messages as read
    fetchTotalUnreadMessages(userId).listen((count) {
      unreadMessageCountCustomer.value = count;
    });
  }

  Stream<List<MessageModel>> fetchUnreadMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiver', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false) // Fetch only unread messages
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                MessageModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<MessageModel> getMessage(String chatRoomId, String messageId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .snapshots() // Listen for real-time updates on the message document
        .map((snapshot) {
      // Convert Firestore document snapshot to MessageModel
      return MessageModel.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  Future<void> updateMessage(
      String chatRoomId, String messageId, bool isReported) async {
    try {
      // Update the 'isReported' field for the specified message in Firestore
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .doc(messageId)
          .update({
        'isReported': isReported,
      });

      print('Message updated successfully.');
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  Future<String?> _getAdminDeviceToken() async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'ADMIN')
          .limit(1)
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        String deviceToken = adminSnapshot.docs.first.get('deviceToken');
        print('Admin device token found: $deviceToken');
        return deviceToken;
      } else {
        print('No admin user found with role ADMIN');
        return null;
      }
    } catch (e) {
      print('Error fetching admin device token: $e');
      return null;
    }
  }

  Future<UserModel?> fetchAdmin() async {
    try {
      final adminSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'ADMIN')
          .limit(1)
          .get();
      if (adminSnapshot.docs.isNotEmpty) {
        // Convert the document data to a UserModel
        return UserModel.fromMap(adminSnapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print("Error fetching admin: $e");
      return null;
    }
  }

  void reportMessage(
      ReportsModel reportsModel, TextEditingController reasonController) async {
    final NotificationService notificationService = NotificationService();

    // Fetch admin's device token
    String? deviceToken = await _getAdminDeviceToken();
    print("Admin device token: $deviceToken");
    String text = reasonController.text.trim();
    if (text.isEmpty) return;
    UserModel? admin = await fetchAdmin();

    // Create a new message object (without id initially)
    ReportsModel report = ReportsModel(
      id: '',
      reported: reportsModel.reported,
      reportedBy: reportsModel.reportedBy,
      messageId: reportsModel.messageId,
      chatroomId: reportsModel.chatroomId,
      reason: text,
      imageUrl: reportsModel.imageUrl ?? '',
      date: DateTime.now(),
    );

    // Add the message to Firestore and get the document reference
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('reports')
        .add(report.toMap());

    // Update the message id with the documentId generated by Firestore
    await docRef.update({'id': docRef.id});
    await updateMessage(
        reportsModel.chatroomId!, reportsModel.messageId!, true);
    if (deviceToken != null) {
      await notificationService.sendPushNotification(
        'Message Reported',
        deviceToken,
        'A user has reported a message. Please review the report and take action.',
        admin!.userId! ?? '',
        "MessageReport",
        docRef.id,
        docRef.id,
      );
      print('Notification sent to admin.');
    } else {
      print('No admin device token found.');
    }

    // Clear the message input field
    reasonController.clear();
  }

  //get report by id
  Future<ReportsModel> getReportById(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('reports').doc(id).get();

    if (snapshot.exists) {
      //print snapshot data
      print(snapshot.data());
      return ReportsModel.fromMap(snapshot.data() as Map<String, dynamic>, id);
    } else {
      throw Exception('Report not found');
    }
  }

  Future<List<String>> fetchDesignerUserIdsFromProducts() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser!.uid;

      // Get the user's document reference
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Get the user's document snapshot
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      // Get the 'products' field from the user's document
      List<DocumentReference> productRefs =
          (userDocSnapshot.data() as Map<String, dynamic>)['products']
                  ?.cast<DocumentReference>() ??
              [];

      // List to store designer userIds
      List<String> designerUserIds = [];

      // Fetch each product document and extract the designer userId
      for (DocumentReference productRef in productRefs) {
        DocumentSnapshot productDoc = await productRef.get();
        String designerUserId = productDoc.get('userId')
            as String; // Assuming the 'userId' field exists
        designerUserIds.add(designerUserId);
      }

      return designerUserIds; // Return the list of designer userIds
    } catch (e) {
      print('Error fetching designer userIds: $e');
      return [];
    }
  }

  Stream<List<UserModel>> fetchDesignersForChat() async* {
    try {
      // Fetch the designer userIds from the products
      List<String> designerUserIds = await fetchDesignerUserIdsFromProducts();

      if (designerUserIds.isEmpty) {
        yield []; // Emit an empty list if no designer userIds found
        return;
      }

      // Listen to real-time updates from the 'users' collection where 'role' is 'Designer'
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('role',
              isEqualTo:
                  'DESIGNER') // Only fetch users with the 'Designer' role
          .where(FieldPath.documentId,
              whereIn: designerUserIds) // Match the userIds from products
          .snapshots() // Listen for real-time updates
          .map((snapshot) {
        // Convert the documents to UserModel and return as a list
        return snapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print('Error fetching designers: $e');
      yield [];
    }
  }

  Stream<List<ChatRoomModel>> fetchAllChatRooms(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.$currentUserId', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  //get total unread messages
  Stream<int> fetchTotalUnreadMessages(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.$currentUserId', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
      int totalUnread = 0;
      for (var chatRoom in snapshot.docs) {
        String chatRoomId = chatRoom.id;
        var unreadMessagesSnapshot = await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .collection('messages')
            .where('isRead', isEqualTo: false)
            .where('receiver', isEqualTo: currentUserId)
            .get();
        totalUnread += unreadMessagesSnapshot.docs.length;
      }
      print("Total unread messages: $totalUnread"); // Debug print
      unreadMessageCount.value = totalUnread;
      return totalUnread;
    });
  }
}
