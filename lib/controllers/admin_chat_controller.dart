import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Firebase/firebase_customerEnd_services.dart';
import '../Model/Chat/chat_room_model.dart';
import '../Model/user/user_model.dart';



class AdminChatController extends GetxController {
  // Observables
  var allChatRooms = <ChatRoomModel>[].obs;
  var filteredChatRooms = <ChatRoomModel>[].obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var error = ''.obs;

  final TextEditingController searchController = TextEditingController();
  final FirebaseCustomerEndServices firebaseCustomerEndServices = FirebaseCustomerEndServices();

  // Cache to store user details and avoid redundant fetches
  final Map<String, UserModel> _userCache = {};

  @override
  void onInit() {
    super.onInit();
    fetchAllChats();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim().toLowerCase();
      filterChatRooms();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch all chat rooms from Firestore
  void fetchAllChats() {
    try {
      isLoading.value = true;
      FirebaseFirestore.instance
          .collection('chatrooms')
          .snapshots()
          .listen((snapshot) {
        allChatRooms.value = snapshot.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        filterChatRooms(); // Apply initial filter
      }, onError: (e) {
        error.value = 'Error fetching chats: $e';
      });
    } catch (e) {
      error.value = 'Error fetching chats: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Filter chat rooms based on search query
  void filterChatRooms() async {
    if (searchQuery.value.isEmpty) {
      filteredChatRooms.value = allChatRooms;
    } else {
      List<ChatRoomModel> tempList = [];

      for (var chatRoom in allChatRooms) {
        List<String> userIds = chatRoom.participants!.keys.toList();

        // Fetch user details with caching
        List<UserModel?> users = await Future.wait(
          userIds.map((userId) => _getUserWithCache(userId)),
        );

        // Check if any user's name contains the search query
        bool matches = users.any((user) =>
        user != null &&
            user.fullName!.toLowerCase().contains(searchQuery.value));

        if (matches) {
          tempList.add(chatRoom);
        }
      }

      filteredChatRooms.value = tempList;
    }
  }

  // Helper method to fetch user with caching
  Future<UserModel?> _getUserWithCache(String userId) async {
    if (_userCache.containsKey(userId)) {
      return _userCache[userId];
    } else {
      UserModel? user = await firebaseCustomerEndServices.fetchUser(userId);
      if (user != null) {
        _userCache[userId] = user;
      }
      return user;
    }
  }
}
