import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/screens/bottomnavbar/custom_navbar.dart';
import 'package:edupot/view/screens/enquiry_form/controller/enquiry_controller.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EnquiryForm extends StatelessWidget {
  final EnquiryFormController controller = Get.put(EnquiryFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorlightgrey,
      appBar: CustomAppBar(
        title: 'Add Enquiry',
        leading: IconButton(
          onPressed: () {
             Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomBottomNavigation()));
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
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Name',
                    icon: Icons.person_outline,
                    validator: requiredValidator,
                    onSaved: (value) {},
                  ),
                  CustomTextField(
                    label: 'Email Address (Optional)',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {},
                    validator: emailValidator,
                  ),
                  CustomTextField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    prefixText: '+91 ',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSaved: (value) {},
                    validator: requiredValidator,
                  ),
                  CustomTextField(
                    label: 'Address',
                    icon: Icons.home_outlined,
                    maxLines: 3,
                    onSaved: (value) {},
                    validator: requiredValidator,
                  ),
                  CustomTextField(
                    label: 'Parent Name',
                    icon: Icons.person_outline,
                    validator: requiredValidator,
                    onSaved: (value) {},
                  ),
                  CustomTextField(
                    label: 'Parent Phone Number',
                    icon: Icons.phone_outlined,
                    prefixText: '+91 ',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSaved: (value) {},
                    validator: requiredValidator,
                  ),
                 
                  
                  // Stream Dropdown with conditional text field
                  Obx(() {
                    return Column(
                      children: [
                        CustomDropdownField(
                          label: 'Stream',
                          icon: Icons.search,
                          items: ['Science', 'Commerce', 'Other'],
                          onChanged: (value) {
                            controller.selectedStream.value = value!;
                          },
                          validator: requiredValidator,
                        ),
                        if (controller.selectedStream.value == 'Other') ...[
                          const SizedBox(height: 16),
                          CustomTextField(
                            label: 'Specify Stream',
                            icon: Icons.text_fields,
                            validator: requiredValidator,
                            onSaved: (value) {},
                          ),
                        ],
                      ],
                    );
                  }),

                  CustomDropdownField(
                    label: 'Status',
                    icon: Icons.search,
                    items: ['Cold', 'Warm', 'Hot'],
                    onChanged: (value) {
                      controller.updateStageItems(value);
                    },
                    validator: requiredValidator,
                  ),
                  Obx(() {
                    return CustomDropdownField(
                      label: 'Stage',
                      icon: Icons.search,
                      items: controller.stageItems.toList(),
                      onChanged: (value) {},
                      validator: requiredValidator,
                    );
                  }),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    onPressed: controller.submitForm,
                    text: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.icon,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    required this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryButton),
          prefixText: prefixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: primaryButton),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ],
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
