import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/view/screens/enquiry_form/widgets/custom_textfield.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Lead student;
   final VoidCallback? onContact;

  const StudentDetailsScreen({super.key, required this.student, this.onContact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Student Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentNameHeader(student: student),
              SizedBox(height: 20),
              ContactInformationSection(student: student),
              SizedBox(height: 20),
              AcademicInformationSection(student: student),
              SizedBox(height: 20),
              PrimaryButton(onPressed: onContact ?? () {
                      // Default action for contact (e.g., call or message)
                      if (kDebugMode) {
                        print('Contacting ');
                      }
                    }, text: 'Contact')
            ],
          ),
        ),
      ),
    );
  }
}

class StudentNameHeader extends StatelessWidget {
  final Lead student;

  const StudentNameHeader({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          student.name.toUpperCase(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class ContactInformationSection extends StatelessWidget {
  final Lead student;

  const ContactInformationSection({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return InformationSection(
      onPressed: () => _editContactFields(context), // Define what happens on edit
      title: 'Contact Information',
      icon: Icons.contact_mail_outlined,
      children: [
        InformationTile(
          icon: Icons.email_outlined,
          title: 'Address',
          subtitle: student.address,
        ),
        InformationTile(
          icon: Icons.phone_outlined,
          title: 'Phone',
          subtitle: student.phone,
        ),
        InformationTile(
          icon: Icons.person_outline,
          title: 'Parent Name',
          subtitle: student.parentName,
        ),
        InformationTile(
          icon: Icons.phone_outlined,
          title: 'Parent Phone',
          subtitle: student.parentPhone,
        ),
      ],
    );
  }
}

class AcademicInformationSection extends StatelessWidget {
  final Lead student;

  const AcademicInformationSection({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return InformationSection(
      onPressed: () => _editAcademicFields(context), // Define what happens on edit
      title: 'Academic Information',
      icon: Icons.school_outlined,
      children: [
        InformationTile(
          icon: Icons.book_outlined,
          title: 'Stream',
          subtitle: student.stream,
        ),
        InformationTile(
          icon: Icons.calendar_today_outlined,
          title: 'Status',
          subtitle: student.status,
        ),
        InformationTile(
          icon: Icons.grade_outlined,
          title: 'Stage',
          subtitle: student.stage,
        ),
        InformationTile(
          icon: Icons.note_outlined,
          title: 'Remark',
          subtitle: student.remark,
        ),
        InformationTile(
          icon: Icons.priority_high_outlined,
          title: 'Priority',
          subtitle: student.priority.toString(),
        ),
      ],
    );
  }
}

class InformationSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final VoidCallback onPressed;

  const InformationSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.onPressed, // Add onPressed as a required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryButton),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onPressed, // Use the onPressed parameter
                icon: const Icon(Icons.edit, color: Colors.teal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class InformationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const InformationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryButton, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

void _editContactFields(BuildContext context) {
  // Implement the logic to edit all fields in the section
  // This could open a dialog where all fields can be edited
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColorlightgrey,
        title: const Text('Edit Contact Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
                label: 'Address', icon: Icons.mail, onSaved: (Value) {}),
            CustomTextField(
                label: 'Phone', icon: Icons.call, onSaved: (Value) {}),
            CustomTextField(
                label: 'Parent Name',
                icon: Icons.person_2_outlined,
                onSaved: (Value) {}),
            CustomTextField(
                label: 'Parent Phone', icon: Icons.phone, onSaved: (Value) {})
            // Add fields for editing here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                iconColor: white, backgroundColor: primaryButton),
            onPressed: () {
              // Save all changes
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: white,
              ),
            ),
          ),
        ],
      );
    },
  );
}



void _editAcademicFields(BuildContext context) {
  // Implement the logic to edit all fields in the section
  // This could open a dialog where all fields can be edited
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColorlightgrey,
        title: const Text('Edit Academic Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
                label: 'Stream', icon: Icons.straighten_sharp, onSaved: (Value) {}),
            CustomTextField(
                label: 'Status', icon: Icons.star_border, onSaved: (Value) {}),
            CustomTextField(
                label: 'Stage',
                icon: Icons.person_2_outlined,
                onSaved: (Value) {}),
            CustomTextField(
                label: 'Remark', icon: Icons.assignment_outlined, onSaved: (Value) {})
            // Add fields for editing here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                iconColor: white, backgroundColor: primaryButton),
            onPressed: () {
              // Save all changes
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: white,
              ),
            ),
          ),
        ],
      );
    },
  );
}