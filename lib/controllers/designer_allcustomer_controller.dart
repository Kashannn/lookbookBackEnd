import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../Model/Chat/chat_room_model.dart';
class DesignerAllCustomerController extends GetxController {

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
}