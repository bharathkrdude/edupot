import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:edupot/view/screens/enquiry_form/widgets/custom_textfield.dart';
import 'package:edupot/view/screens/students_list/widgets/custom_dropdown.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ----------------------------
/// Contact Information Editor
/// ----------------------------
/// Now accepts an optional onUpdated callback.
void _editContactInformation(
  BuildContext context,
  Lead student, {
  VoidCallback? onUpdated,
}) {
  TextEditingController addressController =
      TextEditingController(text: student.address);
  TextEditingController phoneController =
      TextEditingController(text: student.phone);
  TextEditingController parentNameController =
      TextEditingController(text: student.parentName);
  TextEditingController parentPhoneController =
      TextEditingController(text: student.parentPhone);
  TextEditingController emailController =
      TextEditingController(text: student.email ?? '');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColorlightgrey,
        title: const Text('Edit Contact Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Address',
                icon: Icons.location_on_outlined,
                controller: addressController,
                onSaved: (value) => student.address = value ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Phone',
                icon: Icons.phone_outlined,
                controller: phoneController,
                onSaved: (value) => student.phone = value ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Parent Name',
                icon: Icons.person_outline,
                controller: parentNameController,
                onSaved: (value) => student.parentName = value ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Parent Phone',
                icon: Icons.phone_android_outlined,
                controller: parentPhoneController,
                onSaved: (value) => student.parentPhone = value ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email',
                icon: Icons.email_outlined,
                controller: emailController,
                onSaved: (value) => student.email = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryButton),
            onPressed: () {
              // Update the student object.
              student.address = addressController.text;
              student.phone = phoneController.text;
              student.parentName = parentNameController.text;
              student.parentPhone = parentPhoneController.text;
              student.email = emailController.text;
              Navigator.pop(context);
              if (onUpdated != null) {
                onUpdated();
              }
            },
            child: const Text('Save', style: TextStyle(color: white)),
          ),
        ],
      );
    },
  );
}

/// ----------------------------
/// Academic Information Editor
/// ----------------------------
/// This editor uses dropdowns for Stream, Status, and Stage (dependent on Status).
/// It also accepts an onUpdated callback.
void _editAcademicFields(
  BuildContext context,
  Lead student,
  LeadProvider leadProvider,
  VoidCallback? onUpdated,
) {
  // Create a GlobalKey for the form.
  final _formKey = GlobalKey<FormState>();

  // Controllers for text-based fields.
  TextEditingController remarkController =
      TextEditingController(text: student.remark);
  TextEditingController courseController =
      TextEditingController(text: student.course ?? '');

  // Dropdown options.
  final List<String> streamOptions = ['Science', 'Commerce', 'Other'];
  final List<String> statusOptions = ['Cold', 'Warm', 'Hot'];

  // Initialize local state variables with current values.
  String selectedStream = student.stream;
  String selectedStatus = student.status;
  String selectedStage = student.stage;

  // Helper function to get stage items based on status.
  List<String> getStageItems(String status) {
    switch (status) {
      case 'Warm':
        return ['Call Back', 'FollowUp'];
      case 'Hot':
        return ['Zoom Meeting', 'Physical Meeting', 'Closed', 'Not Interested'];
      case 'Cold':
        return ['DNP', 'RNR', 'Call Back'];
      default:
        return [];
    }
  }

  // Initialize stage items.
  List<String> stageItems = getStageItems(selectedStatus);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: backgroundColorlightgrey,
          title: const Text('Edit Academic Information'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 // Stream Dropdown
    CustomDropdown(
      value: selectedStream,
      labelText: 'Stream',
      items: streamOptions,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedStream = value;
          });
        }
      },
    ),
    const SizedBox(height: 12),
    
    // Status Dropdown
    CustomDropdown(
      value: selectedStatus,
      labelText: 'Status',
      items: statusOptions,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedStatus = value;
            // Reset stage when status changes
            selectedStage = '';
            stageItems = getStageItems(selectedStatus);
          });
        }
      },
    ),
    const SizedBox(height: 12),
    
    // Stage Dropdown
    CustomDropdown(
      value: selectedStage,
      labelText: 'Stage',
      items: stageItems,
      allowEmpty: true,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedStage = value;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a stage';
        }
        return null;
      },
    ),
                  const SizedBox(height: 12),
                  // CustomTextField for Remark.
                  CustomTextField(
                    label: 'Remark',
                    icon: Icons.assignment_outlined,
                    controller: remarkController,
                    onSaved: (value) => student.remark = value ?? '',
                  ),
                  const SizedBox(height: 12),
                  // CustomTextField for Course.
                  CustomTextField(
                    label: 'Course',
                    icon: Icons.school_outlined,
                    controller: courseController,
                    onSaved: (value) => student.course = value ?? '',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: primaryButton),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();

                  // Update dropdown values.
                  student.stream = selectedStream;
                  student.status = selectedStatus;
                  student.stage = selectedStage;

                  bool success = await leadProvider.updateLead(student);
                  if (success) {
                    Navigator.pop(context);
                    if (onUpdated != null) {
                      onUpdated();
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Failed to update lead. Please try again.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save', style: TextStyle(color: white)),
            ),
          ],
        );
      });
    },
  );
}

/// ----------------------------
/// Main Screen (Stateful)
/// ----------------------------
class StudentDetailsScreen extends StatefulWidget {
  final Lead student;
  final VoidCallback? onContact;

  const StudentDetailsScreen({Key? key, required this.student, this.onContact})
      : super(key: key);

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Student Details',
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentNameHeader(student: widget.student),
              const SizedBox(height: 20),
              // Pass onUpdated callback to refresh UI after editing.
              ContactInformationSection(
                student: widget.student,
                onUpdated: () {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              AcademicInformationSection(
                student: widget.student,
                onUpdated: () {
                  setState(() {}); // Refresh UI when academic info is updated.
                },
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onPressed: widget.onContact ??
                    () {
                      if (kDebugMode) {
                        print('Contacting...');
                      }
                    },
                text: 'Contact',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------------
/// Header & Section Widgets
/// ----------------------------
class StudentNameHeader extends StatelessWidget {
  final Lead student;
  const StudentNameHeader({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          student.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

/// Contact Information Section now accepts an onUpdated callback.
class ContactInformationSection extends StatelessWidget {
  final Lead student;
  final VoidCallback? onUpdated;
  const ContactInformationSection({Key? key, required this.student, this.onUpdated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InformationSection(
      onPressed: () => _editContactInformation(
        context,
        student,
        onUpdated: onUpdated,
      ),
      title: 'Contact Information',
      icon: Icons.contact_mail_outlined,
      children: [
        InformationTile(
          icon: Icons.location_on_outlined,
          title: 'Address',
          subtitle: student.address ?? '-',
        ),
        InformationTile(
          icon: Icons.phone_outlined,
          title: 'Phone',
          subtitle: student.phone,
        ),
        InformationTile(
          icon: Icons.person_outline,
          title: 'Parent Name',
          subtitle: student.parentName ?? '-',
        ),
        InformationTile(
          icon: Icons.phone_android_outlined,
          title: 'Parent Phone',
          subtitle: student.parentPhone ?? '-',
        ),
        InformationTile(
          icon: Icons.email_outlined,
          title: 'Email',
          subtitle: student.email ?? '-',
        ),
      ],
    );
  }
}

/// Academic Information Section accepts an onUpdated callback.
class AcademicInformationSection extends StatelessWidget {
  final Lead student;
  final VoidCallback? onUpdated;
  const AcademicInformationSection({Key? key, required this.student, this.onUpdated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context, listen: false);
    return InformationSection(
      onPressed: () =>
          _editAcademicFields(context, student, leadProvider, onUpdated),
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
          subtitle: student.remark ?? '-',
        ),
        InformationTile(
          icon: Icons.priority_high_outlined,
          title: 'Course',
          subtitle: student.course ?? '-',
        ),
      ],
    );
  }
}

/// ----------------------------
/// InformationSection & Tile
/// ----------------------------
class InformationSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final VoidCallback onPressed;

  const InformationSection({
    Key? key,
    required this.title,
    required this.icon,
    required this.children,
    required this.onPressed,
  }) : super(key: key);

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
                onPressed: onPressed,
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
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryButton, size: 20),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
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
