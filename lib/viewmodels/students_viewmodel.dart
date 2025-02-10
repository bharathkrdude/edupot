import 'dart:async';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:flutter/material.dart';
import 'package:edupot/data/models/leads_model.dart';

class StudentViewModel extends ChangeNotifier {
  final LeadProvider _leadProvider;
  final _studentsController = StreamController<List<Lead>>.broadcast();

  List<Lead> _students = [];
  List<Lead> _filteredStudents = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  int _perPage = 99; // Keep perPage constant (adjust based on API)
  int _totalPages = 1;
  int _totalStudents = 0;
  String _errorMessage = '';


  String? _selectedStage;
  String? _fromDate;
  String? _toDate;

  StudentViewModel(this._leadProvider) {
    fetchStudents();
  }

  Stream<List<Lead>> get studentsStream => _studentsController.stream;
  List<Lead> get students => _filteredStudents.isNotEmpty ? _filteredStudents : _students;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _currentPage < _totalPages;
  String get errorMessage => _errorMessage;
  int get totalStudents => _totalStudents;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  
Future<void> fetchStudents({bool isRefresh = false}) async {
  if (_isLoading || (!_hasMoreData && !isRefresh)) return;

  if (isRefresh) {
    _currentPage = 1;
    _hasMoreData = true;
    _students.clear();
  }

  _isLoading = true;
  notifyListeners();

  try {
    final response = await _leadProvider.fetchLeads(
      page: _currentPage,
      perPage: _perPage, 
      stage: _selectedStage,
      fromDate: _fromDate,
      toDate: _toDate,
    );

    final List<Lead> newStudents = response['leads'];
    final int totalRecords = response['total']; // API must provide total records

    if (isRefresh) {
      _students = newStudents;
    } else {
      _students.addAll(newStudents);
    }

    // Pagination check: If we received less than requested, no more data
    _hasMoreData = newStudents.length >= 20;
    
    // Update currentPage only if new data is available
    if (_hasMoreData) {
      _currentPage++;
    }

    _studentsController.add(_students);
    _errorMessage = '';
  } catch (e) {
    _errorMessage = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Fetch more students when scrolling
  Future<void> fetchMoreStudents() async {
    if (!_isLoading && _hasMoreData) {
      await fetchStudents();
    }
  }

  // Refresh students list
  Future<void> refreshStudents() async {
    await fetchStudents(isRefresh: true);
  }

  // Apply filters and refetch data
  void applyFilters({String? stage, String? fromDate, String? toDate}) {
    _selectedStage = stage;
    _fromDate = fromDate;
    _toDate = toDate;
    refreshStudents();
  }
void resetFilters() {
  _selectedStage = null;
  _fromDate = null;
  _toDate = null;
  fetchStudents(isRefresh: true); 
  notifyListeners();
}

  
  void searchStudents(String query) {
    if (query.isEmpty) {
      _filteredStudents = [];
    } else {
      _filteredStudents = _students
          .where((student) =>
              student.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    _studentsController.add(_filteredStudents);
    notifyListeners();
  }

  @override
  void dispose() {
    _studentsController.close();
    super.dispose();
  }
}
