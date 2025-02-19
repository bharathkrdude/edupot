import 'dart:async';
import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:flutter/material.dart';

class StudentViewModel extends ChangeNotifier {
  final LeadProvider _leadProvider;
  final _studentsController = StreamController<List<Lead>>.broadcast();

  List<Lead> _students = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _perPage = 20;
  int _totalPages = 1;
  int _totalStudents = 0;
  String _errorMessage = '';

  // Filter values
  String? _selectedStage;
  String? _fromDate;
  String? _toDate;
  String? _staff;
  String? _allData; // for search query

  StudentViewModel(this._leadProvider) {
    fetchStudents();
  }

  Stream<List<Lead>> get studentsStream => _studentsController.stream;
  List<Lead> get students => _students;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;
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
      print('Fetching leads: page=$_currentPage, perPage=$_perPage, '
          'stage=$_selectedStage, staff=$_staff, fromDate=$_fromDate, toDate=$_toDate, allData=$_allData');

      final leadsResponse = await _leadProvider.fetchLeads(
        page: _currentPage,
        perPage: _perPage,
        stage: _selectedStage,
        fromDate: _fromDate,
        toDate: _toDate,
        staff: _staff,
        allData: _allData,
      );

      final List<Lead> newStudents = leadsResponse.leads;
      final int totalRecords = leadsResponse.totalCount;

      print('API Response: total_count=$totalRecords, newStudents=${newStudents.length}');

      _totalStudents = totalRecords;
      _totalPages = (totalRecords / _perPage).ceil();
      print('Total pages calculated: $_totalPages');

      _students.addAll(newStudents);

      if (newStudents.length < _perPage) {
        _hasMoreData = false;
        print('Fetched less than perPage ($_perPage). Setting _hasMoreData = false');
      } else {
        _currentPage++;
        _hasMoreData = _currentPage <= _totalPages;
        print('Incrementing page. New currentPage=$_currentPage, hasMoreData=$_hasMoreData');
      }

      print('Total students in list: ${_students.length}');
      _studentsController.add(List.from(_students));
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      print('Error fetching leads: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreStudents() async {
    if (!_isLoading && _hasMoreData) {
      await fetchStudents();
    }
  }

  Future<void> refreshStudents() async {
    await fetchStudents(isRefresh: true);
  }

  void applyFilters({String? stage, String? fromDate, String? toDate, String? staff}) {
    _selectedStage = stage;
    _fromDate = fromDate;
    _toDate = toDate;
    _staff = staff;
    refreshStudents();
  }

  void resetFilters() {
    _selectedStage = null;
    _fromDate = null;
    _toDate = null;
    _staff = null;
    _allData = null;
    refreshStudents();
    notifyListeners();
  }

  // API-based search: set the _allData parameter and refresh the list.
  void searchStudents(String query) {
    _allData = query.isEmpty ? null : query;
    refreshStudents();
  }

  @override
  void dispose() {
    _studentsController.close();
    super.dispose();
  }
}
