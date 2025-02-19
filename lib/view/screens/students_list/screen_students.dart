import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/view/screens/student_details/student_details.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/search_widget.dart';
import 'package:edupot/viewmodels/students_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/student_listtile.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ScreenStudents extends StatefulWidget {
  const ScreenStudents({super.key});

  @override
  State<ScreenStudents> createState() => _ScreenStudentsState();
}

class _ScreenStudentsState extends State<ScreenStudents> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;
  String? selectedStage;
  String? selectedStaff;
  String? fromDate;
  String? toDate;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchInitialStudents();
  }

  void _fetchInitialStudents() {
    final viewModel = context.read<StudentViewModel>();
    if (!_isFetching) {
      _isFetching = true;
      viewModel.fetchStudents().then((_) {
        _isFetching = false;
      });
    }
  }

  void _onScroll() {
    final viewModel = context.read<StudentViewModel>();
    if (!_isFetching &&
        viewModel.hasMoreData &&
        _scrollController.position.extentAfter < 300) {
      _fetchMoreStudents();
    }
  }

  void _fetchMoreStudents() {
    final viewModel = context.read<StudentViewModel>();
    if (!_isFetching && viewModel.hasMoreData) {
      _isFetching = true;
      viewModel.fetchMoreStudents().then((_) {
        _isFetching = false;
      });
    }
  }

  Future<List<String>> fetchStaffList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('Bearer token not found');
        return [];
      }

      final response = await http.get(
        Uri.parse('https://edupotstudy.com/api/v1/staff-list'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true && data['staffs'] != null) {
          return List<String>.from(
              data['staffs'].map((staff) => staff['name'] as String));
        }
      } else {
        print('Unexpected response format: ${response.body}');
      }
      return [];
    } catch (e) {
      print('Error fetching staff list: $e');
      return [];
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Leads',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Staff Selection
                  FutureBuilder<List<String>>(
                    future: fetchStaffList(),
                    builder: (context, snapshot) {
                      
                      if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      Widget content;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        content = const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        content = Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: const Text('Unable to load staff list'),
                        );
                      } else {
                        content = Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: [
                              for (int i = 0;
                                  i < snapshot.data!.length;
                                  i++) ...[
                                if (i > 0) _buildDivider(),
                                _buildStaffOption(
                                  snapshot.data![i],
                                  selectedStaff,
                                  (staff) => setBottomSheetState(
                                      () => selectedStaff = staff),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          const Text(
                            'Staff',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          content,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildStatusOption(
                            'RNR', selectedStage, setBottomSheetState),
                        _buildDivider(),
                        _buildStatusOption(
                            'DNP', selectedStage, setBottomSheetState),
                        _buildDivider(),
                        _buildStatusOption(
                            'FollowUp', selectedStage, setBottomSheetState),
                        _buildDivider(),
                        _buildStatusOption('Not Interested', selectedStage,
                            setBottomSheetState),
                        _buildDivider(),
                        _buildStatusOption(
                            'Zoom Meeting', selectedStage, setBottomSheetState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Date Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          fromDate ?? 'From',
                          () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fromDate != null
                                  ? DateFormat('dd-MM-yyyy').parse(fromDate!)
                                  : DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: primaryButton),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setBottomSheetState(() {
                                fromDate =
                                    DateFormat('dd-MM-yyyy').format(picked);
                                if (toDate != null &&
                                    picked.isAfter(DateFormat('dd-MM-yyyy')
                                        .parse(toDate!))) {
                                  toDate = null;
                                }
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDateField(
                          toDate ?? 'To',
                          () async {
                            if (fromDate == null) return;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: toDate != null
                                  ? DateFormat('dd-MM-yyyy').parse(toDate!)
                                  : DateTime.now(),
                              firstDate:
                                  DateFormat('dd-MM-yyyy').parse(fromDate!),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                        primary: primaryButton),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setBottomSheetState(() {
                                toDate =
                                    DateFormat('dd-MM-yyyy').format(picked);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          onPressed: () {
                            setBottomSheetState(() {
                              selectedStage = null;
                              selectedStaff = null;
                              fromDate = null;
                              toDate = null;
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryButton,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            print('About to apply filters with:');
                            print('Stage: $selectedStage');
                            print('Staff: $selectedStaff'); 
                            print('From Date: $fromDate');
                            print('To Date: $toDate');
                            context.read<StudentViewModel>().applyFilters(
                                  stage: selectedStage,
                                  fromDate: fromDate,
                                  toDate: toDate,
                                  staff: selectedStaff,
                                );
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStaffOption(
      String name, String? selectedStaff, Function(String) onSelect) {
    final isSelected = name == selectedStaff;

    return InkWell(
      onTap: () {
        print('Staff option tapped: $name'); 
        onSelect(name);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                color: isSelected ? primaryButton : Colors.black87,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: primaryButton,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(
      String status, String? selectedStatus, StateSetter setState) {
    final isSelected = status == selectedStatus;

    return InkWell(
      onTap: () => setState(() => selectedStage = status),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status,
              style: TextStyle(
                color: isSelected ? primaryButton : Colors.black87,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: primaryButton,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String text, VoidCallback onTap) {
    final isPlaceholder = text == 'From' || text == 'To';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isPlaceholder ? Colors.grey[600] : Colors.black87,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorlightgrey,
      appBar: CustomAppBar(
        title: 'Students',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: StreamBuilder<List<Lead>>(
        stream: context.watch<StudentViewModel>().studentsStream,
        builder: (context, snapshot) {
          final viewModel = context.watch<StudentViewModel>();
          final students = snapshot.data ?? [];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchWidget(
                  onChanged: (value) => viewModel.searchStudents(value),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: viewModel.refreshStudents,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: students.length + 1,
                    itemBuilder: (context, index) {
                      if (index == students.length) {
                        if (viewModel.hasMoreData) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ));
                        } else {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("No more students"),
                          ));
                        }
                      }
                      final lead = students[index];
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: StudentListTile(
                          name: '${index + 1}. ${lead.name}',
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
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          );
        },
      ),
    );
  }

  void makeCall(String phone) async {
    await FlutterPhoneDirectCaller.callNumber(phone);
  }
}
