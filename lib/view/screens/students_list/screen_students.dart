import 'package:edupot/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/view/screens/student_details/student_details.dart';
import 'package:edupot/view/screens/students_list/widgets/student_listtile.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';

class ScreenStudents extends StatelessWidget {
  const ScreenStudents({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: CustomAppBar(title: 'Students'),
      body: FutureBuilder<List<Lead>>(
        future: apiService.fetchLeads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No students found.'));
          } else {
            final leads = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return Column(
                  children: [
                    StudentListTile(
                      name: lead.name,
                      stream: lead.stream,
                      phone: lead.phone,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetailsScreen(student: lead),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
