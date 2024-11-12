
import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class EnquiryForm extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: backgroundColorlightgrey,
      appBar: CustomAppBar(title: 'Add enquiry',leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back,color: white,) ),),
      // Replace with your background color variable
      body: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColorlightgrey, // Replace with your container background color
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Name Field
                  CustomTextField(
                    label: 'Name',
                    icon: Icons.person_outline,
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    }, onSaved: (value) {  },
                  ),
                  // Email Field
                  CustomTextField(
                    label: 'Email Address (Optional)',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                   onSaved: (Value){},
                    validator: (value) {
                      if (value != null && value.isNotEmpty && !GetUtils.isEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  // Phone Field
                  CustomTextField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    prefixText: '+91 ',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onSaved: (Value){},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  // Address Field
                  CustomTextField(
                    label: 'Address',
                    icon: Icons.home_outlined,
                    maxLines: 3,
                   onSaved: (Value){},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  // Enquiry About Dropdown
                  CustomDropdownField(
                    label: 'Enquiry About',
                    icon: Icons.help_outline,
                    items: ['Kitchen Design', 'Interior Decoration', 'Renovation', 'Other'],
                   
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }
                      return null;
                    }, onChanged: (Value ) {  },
                  ),
                  // How Did You Find Us Dropdown
                  CustomDropdownField(
                    label: 'How Did You Find Us?',
                    icon: Icons.search,
                    items: ['Google', 'Social Media', 'Referral', 'Other'],
                    onChanged: (Value){},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  // Submit Button
                 PrimaryButton(onPressed: (){}, text: 'Submit')
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
          fillColor: white,
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
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryButton),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: white,
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
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red.shade600,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
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
