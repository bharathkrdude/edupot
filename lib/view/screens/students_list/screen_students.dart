import 'package:edupot/view/screens/student_details/student_details.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/viewmodels/students_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'widgets/student_listtile.dart';

class ScreenStudents extends StatefulWidget {
  const ScreenStudents({super.key});

  @override
  State<ScreenStudents> createState() => _ScreenStudentsState();
}

class _ScreenStudentsState extends State<ScreenStudents> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StudentViewModel>().fetchStudents();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Students',
        // Add pagination info in the action
        actions: [
          Consumer<StudentViewModel>(
            builder: (context, viewModel, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Page ${viewModel.currentPage - 1}/${viewModel.totalPages}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<StudentViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.errorMessage.isNotEmpty && viewModel.students.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${viewModel.errorMessage}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.refreshStudents,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Pagination info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Students: ${viewModel.totalStudents}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: viewModel.refreshStudents,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12.0),
                    itemCount: viewModel.students.length + 1,
                    itemBuilder: (context, index) {
                      if (index == viewModel.students.length) {
                        if (viewModel.isLoading) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (!viewModel.hasMoreData) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No more students'),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }

                      final lead = viewModel.students[index];
                      return Column(
                        children: [
                          StudentListTile(
                            name:
                                '${index + 1}. ${lead.name}', // Add index number
                            stream: lead.stream,
                            phone: lead.phone,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentDetailsScreen(
                                    student: lead,
                                    onContact: () => makeCall(lead.phone),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void makeCall(String phone) async {
  try {
    await FlutterPhoneDirectCaller.callNumber(phone);
  } catch (e) {
    if (kDebugMode) {
      print('Error making call: $e');
    }
  }
}
