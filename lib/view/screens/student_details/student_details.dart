import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Lead student;

  const StudentDetailsScreen({super.key, required this.student});

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
              FullWidthActionButton(phone: student.phone),
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
        color: primaryButton.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          student.name,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: primaryButton,
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

  const InformationSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryButton),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
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

class FullWidthActionButton extends StatelessWidget {
  final String phone;

  const FullWidthActionButton({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // Add call functionality here
        },
        icon: Icon(Icons.call, color: Colors.white),
        label: Text('Call', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryButton,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

// class Student {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String parentName;
//   final String parentPhone;
//   final String stream;
//   final String status;
//   final String stage;
//   final String remark;
//   final int priority;
  

//   Student({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.parentName,
//     required this.parentPhone,
//     required this.stream,
//     required this.status,
//     required this.stage,
//     required this.remark,
//     required this.priority,
  
//   });
// }
