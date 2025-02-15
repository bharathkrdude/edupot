import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:edupot/view/screens/bottomnavbar/custom_navbar.dart';
import 'package:edupot/view/screens/enquiry_form/widgets/custom_dropdown.dart';
import 'package:edupot/view/screens/enquiry_form/widgets/custom_textfield.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:edupot/viewmodels/enquiry_form_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EnquiryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context);
    final viewModel = EnquiryFormViewModel(leadProvider: leadProvider);

    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CustomBottomNavigation(),
        ));
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColorlightgrey,
        appBar: CustomAppBar(
          title: 'Add Enquiry',
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CustomBottomNavigation(),
              ));
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColorlightgrey,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Name',
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      onSaved: (value) => viewModel.name = value,
                    ),
                    CustomTextField(
                      label: 'Email Address (Optional)',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => viewModel.email = value,
                      validator: (value) => value != null &&
                              value.isNotEmpty &&
                              !GetUtils.isEmail(value)
                          ? 'Invalid email'
                          : null,
                    ),
                    CustomTextField(
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      prefixText: '+91 ',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) => viewModel.phone = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    CustomTextField(
                      label: 'Address',
                      icon: Icons.home_outlined,
                      maxLines: 3,
                      onSaved: (value) => viewModel.address = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    CustomTextField(
                      label: 'Parent Name',
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      onSaved: (value) => viewModel.parentName = value,
                    ),
                    CustomTextField(
                      label: 'Parent Phone Number',
                      icon: Icons.phone_outlined,
                      prefixText: '+91 ',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) => viewModel.parentPhone = value,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                    CustomTextField(
                      label: 'Course',
                      icon: Icons.book_outlined,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      onSaved: (value) => viewModel.course =
                          value, // Fixed: Changed from parentName to remark
                    ),
                    CustomTextField(
                      label: 'Remark',
                      icon: Icons.note_alt,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                      onSaved: (value) => viewModel.remark =
                          value, // Fixed: Changed from parentName to remark
                    ),

                    
                    

                    // Stream Dropdown with conditional text field
                    Obx(() => Column(
                          children: [
                            CustomDropdownField(
                              label: 'Stream',
                              icon: Icons.search,
                              items: ['Science', 'Commerce','Humanities' ,'Other'],
                              value: viewModel.selectedStream.value,
                              onChanged: viewModel.updateStream,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                            ),
                            if (viewModel.selectedStream.value == 'Other')
                              CustomTextField(
                                label: 'Specify Stream',
                                icon: Icons.text_fields,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                                onSaved: (value) =>
                                    viewModel.customStream = value,
                              ),
                          ],
                        )),
                    // Status and Stage Dropdowns
                    Obx(() => Column(
                          children: [
                            // Status Dropdown
                            CustomDropdownField(
                              label: 'Status',
                              icon: Icons.search,
                              items: const ['Cold', 'Warm', 'Hot'],
                              value: viewModel.selectedStatus.value.isEmpty
                                  ? null
                                  : viewModel.selectedStatus.value,
                              onChanged: viewModel.updateStatus,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                            ),

                            // Stage Dropdown (only shown if status is selected)
                            if (viewModel.selectedStatus.value.isNotEmpty)
                              CustomDropdownField(
                                label: 'Stage',
                                icon: Icons.search,
                                items: viewModel.stageItems,
                                value: viewModel.selectedStage.value.isEmpty
                                    ? null
                                    : viewModel.selectedStage.value,
                                onChanged: viewModel.updateStage,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                              ),
                          ],
                        )),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      onPressed: () async {
                        await viewModel.submitForm(context);
                      },
                      text: 'Submit',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value != null && value.isNotEmpty) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
  }
  return null;
}
