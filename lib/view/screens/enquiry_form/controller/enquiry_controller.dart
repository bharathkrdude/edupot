import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnquiryFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final status = ''.obs;
    var selectedStream = ''.obs;
  final stageItems = <String>[].obs; // Ensure an observable list is initialized

  void updateStageItems(String? selectedStatus) {
    // Ensure that stageItems updates correctly based on the status
    if (selectedStatus == 'Warm') {
      stageItems.value = ['Call Back', 'FollowUp'];
    } else if (selectedStatus == 'Hot') {
      stageItems.value = ['Zoom', 'Physical Meeting', 'Closed', 'Not Interested'];
    } else {
      stageItems.value = ['DND', 'RNR', 'Call Back'];
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Handle form submission logic here
    }
  }
}
