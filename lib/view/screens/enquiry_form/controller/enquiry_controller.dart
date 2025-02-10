import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnquiryFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Separate observables for Stream and Stage
  final selectedStream = ''.obs;
  final selectedStage = ''.obs;

  final stageItems = <String>[].obs;

  void updateStageItems(String? selectedStatus) {
    if (selectedStatus == null || selectedStatus.isEmpty) {
      stageItems.clear();
      selectedStage.value = ''; // Reset selectedStage
      return;
    }

    switch (selectedStatus) {
      case 'Warm':
        stageItems.value = ['Call Back', 'FollowUp'].toSet().toList();
        break;
      case 'Hot':
        stageItems.value = ['Zoom Meeting', 'Physical Meeting', 'Closed', 'Not Interested'].toSet().toList();
        break;
      case 'Cold':
        stageItems.value = ['DNP', 'RNR', 'Call Back'].toSet().toList();
        break;
      default:
        stageItems.clear();
        selectedStage.value = ''; // Reset selectedStage
    }

    // Reset selectedStage if it's not in stageItems
    if (!stageItems.contains(selectedStage.value)) {
      selectedStage.value = '';
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
