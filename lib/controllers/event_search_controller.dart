import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Firebase/firebase_customerEnd_services.dart';

class EventController extends GetxController {
  final FirebaseCustomerEndServices firebaseCustomerEndServices =
      FirebaseCustomerEndServices();
  RxList<String> events = <String>[].obs;
  RxList<String> filteredEvents = <String>[].obs;
  RxBool isEventSelected = true.obs;
  TextEditingController searchController = TextEditingController();
  RxString selectedEvent = ''.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  var focusedDay = DateTime.now().obs;
  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    searchController.addListener(() {
      filterEvents();
    });
  }

  void fetchEvents() async {
    firebaseCustomerEndServices.fetchEvents().listen((List<String> eventList) {
      events.value = eventList;
      filterEvents();
    });
  }
  void clearSelections() {
    isEventSelected.value = true;
    selectedEvent.value = '';
    selectedDate.value = null;
  }

  void filterEvents() {
    String query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredEvents.value = events;
    } else {
      filteredEvents.value =
          events.where((event) => event.toLowerCase().contains(query)).toList();
    }
  }

  void selectEvent(String event) {
    selectedEvent.value = event;
    isEventSelected.value = false;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
