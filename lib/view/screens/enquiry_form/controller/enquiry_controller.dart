import 'package:flutter/material.dart';
import 'package:get/get.dart';
class EnquiryFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final status = ''.obs;
  final selectedStream = ''.obs;
  final stageItems = <String>[].obs;

  void updateStageItems(String? selectedStatus) {
    if (selectedStatus == null || selectedStatus.isEmpty) {
      stageItems.clear();
      selectedStream.value = ''; // Reset selectedStream
      return;
    }

    switch (selectedStatus) {
      case 'Warm':
        stageItems.value = ['Call Back', 'FollowUp'].toSet().toList();
        break;
      case 'Hot':
        stageItems.value = ['Zoom', 'Physical Meeting', 'Closed', 'Not Interested'].toSet().toList();
        break;
      case 'Cold':
        stageItems.value = ['DND', 'RNR', 'Call Back'].toSet().toList();
        break;
      default:
        stageItems.clear();
        selectedStream.value = ''; // Reset selectedStream
    }

    // Reset selectedStream if it's not in stageItems
    if (!stageItems.contains(selectedStream.value)) {
      selectedStream.value = '';
    }
  }

  void submitForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      Get.snackbar(
        'Success',
        'Form submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fill out all fields correctly.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
