import 'package:edupot/data/repositories/lead_provider.dart';
import 'package:flutter/material.dart';
import 'package:edupot/data/models/leads_model.dart';
class StudentViewModel extends ChangeNotifier {
  final LeadProvider _leadProvider;
  
  List<Lead> _students = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalStudents = 0;
  String _errorMessage = '';

  StudentViewModel(this._leadProvider) {
    fetchStudents();
  }

  List<Lead> get students => _students;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _currentPage < _totalPages;
  String get errorMessage => _errorMessage;
  int get totalStudents => _totalStudents;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> fetchStudents() async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _leadProvider.fetchLeads(
        page: _currentPage,
        perPage: 10,
      );

      final List<Lead> newStudents = response['leads'];
      _totalStudents = response['total'];
      _totalPages = response['last_page'];
      
      if (_currentPage == 1) {
        _students = newStudents;
      } else {
        _students.addAll(newStudents);
      }
      
      _currentPage++;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStudents() async {
    _students.clear();
    _currentPage = 1;
    _hasMoreData = true;
    _errorMessage = '';
    notifyListeners();
    await fetchStudents();
  }
}
