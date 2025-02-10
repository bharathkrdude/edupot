import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/view/screens/student_details/student_details.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/search_widget.dart';
import 'package:edupot/viewmodels/students_viewmodel.dart';
import 'widgets/student_listtile.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';

class ScreenStudents extends StatefulWidget {
  const ScreenStudents({super.key});

  @override
  State<ScreenStudents> createState() => _ScreenStudentsState();
}

class _ScreenStudentsState extends State<ScreenStudents> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;
  String? selectedStage;
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
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9) {
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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Leads',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedStage,
                    decoration: const InputDecoration(
                      labelText: 'Stage',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      'RNR',
                      'DNP',
                      'FollowUp',
                      'Not Interested',
                      'Zoom Meeting'
                    ]
                        .map((stage) =>
                            DropdownMenuItem(value: stage, child: Text(stage)))
                        .toList(),
                    onChanged: (value) {
                      setBottomSheetState(() => selectedStage = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: fromDate != null
                                  ? DateFormat('dd-MM-yyyy').parse(fromDate!)
                                  : DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
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
                          child:
                              _buildDateField(fromDate ?? 'Select From Date'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: toDate != null
                                  ? DateFormat('dd-MM-yyyy').parse(toDate!)
                                  : DateTime.now(),
                              firstDate: fromDate != null
                                  ? DateFormat('dd-MM-yyyy').parse(fromDate!)
                                  : DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setBottomSheetState(() => toDate =
                                  DateFormat('dd-MM-yyyy').format(picked));
                            }
                          },
                          child: _buildDateField(toDate ?? 'Select To Date'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300),
                          onPressed: () {
                            setBottomSheetState(() {
                              selectedStage = null;
                              fromDate = null;
                              toDate = null;
                            });
                          },
                          child: const Text('Reset',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryButton),
                          onPressed: () {
                            context.read<StudentViewModel>().applyFilters(
                                  stage: selectedStage,
                                  fromDate: fromDate,
                                  toDate: toDate,
                                );
                            setState(() {}); // Force UI refresh
                            Navigator.pop(context);
                          },
                          child: const Text('Apply',
                              style: TextStyle(color: white)),
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

  /// Custom Date Field Widget
  Widget _buildDateField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16)),
          const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
        ],
      ),
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
                    itemCount:
                        students.length + (viewModel.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == students.length) {
                        return const Center(child: CircularProgressIndicator());
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
              SizedBox(height: 60,)
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
