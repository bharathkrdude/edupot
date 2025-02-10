import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:edupot/view/widgets/success_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnquiryFormViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LeadProvider leadProvider;

  String? name;
  String? address;
  String? phone;
  String? email;
  String? parentName;
  String? parentPhone;
  String? stream;
  String? customStream;
  String? status;
  String? stage;
  String? course;
  String? remark;
  final RxInt star = 0.obs; // Changed from rating to star

  final RxString selectedStream = ''.obs;
   final RxString selectedStatus = ''.obs;
  final RxString selectedStage = ''.obs;
  final RxList<String> stageItems = <String>[].obs;

  EnquiryFormViewModel({required this.leadProvider});

  // void updateStar(int value) { // Changed from updateRating to updateStar
  //   star.value = value;
  // }

  void updateStream(String? value) {
    selectedStream.value = value ?? '';
    stream = value;
    if (value != 'Other') {
      customStream = null;
    }
  }
   void updateStatus(String? value) {
    if (value != null) {
      selectedStatus.value = value;
      status = value;
      // Reset stage when status changes
      selectedStage.value = '';
      stage = null;
      updateStageItems(value);
    }
  }

  void updateStageItems(String status) {
    switch (status) {
      case 'Warm':
        stageItems.value = ['Call Back', 'FollowUp'];
        break;
      case 'Hot':
        stageItems.value = ['Zoom Meeting', 'Physical Meeting', 'Closed', 'Not Interested'];
        break;
      case 'Cold':
        stageItems.value = ['DNP', 'RNR', 'Call Back'];
        break;
      default:
        stageItems.clear();
    }
  }

  void updateStage(String? value) {
    if (value != null) {
      selectedStage.value = value;
      stage = value;
    }
  }
Future<void> submitForm(BuildContext context) async {
  try {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (name == null || 
          address == null || 
          phone == null || 
          parentName == null || 
          parentPhone == null || 
          stream == null || 
          status == null || 
          stage == null ||
          remark == null) {
        _showSnackBar(context, 'Error', 'Please fill out all required fields.');
        return;
      }

      Lead newLead = Lead(
        id: 0,
        name: name!,
        address: address!,
        phone: phone!,
        email: email,
        parentName: parentName!,
        parentPhone: parentPhone!,
        stream: stream!,
        customStream: stream == "Other" ? customStream : null,
        status: status!,
        stage: stage!,
        course: course,
        remark: remark!,
        // star: star.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _showLoadingDialog(context);

      try {
        final success = await leadProvider.addLead(newLead);
        // Close loading dialog
        Navigator.of(context, rootNavigator: true).pop();

        if (success) {
          // Navigate to success page and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => SuccessPage(),
            ),
            (route) => false,
          );
        } else {
          _showSnackBar(context, 'Error', 'Failed to submit enquiry. Please try again.');
        }
      } catch (apiError) {
        Navigator.of(context, rootNavigator: true).pop();
        print('API Error: $apiError');
        _showSnackBar(context, 'Error', 'Failed to connect to server. Please try again.');
      }
    }
  } catch (e) {
    print('Error during form submission: $e');
    _showSnackBar(context, 'Error', 'An unexpected error occurred: $e');
  }
}

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _resetForm() {
    formKey.currentState!.reset();
    name = null;
    address = null;
    phone = null;
    email = null;
    parentName = null;
    parentPhone = null;
    stream = null;
    customStream = null;
    status = null;
    stage = null;
    course = null;
    remark = null;
    star.value = 0;
    selectedStream.value = '';
  }

  void _showSnackBar(BuildContext context, String title, String message) {
    final snackBar = SnackBar(
      content: Text('$title: $message'),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
