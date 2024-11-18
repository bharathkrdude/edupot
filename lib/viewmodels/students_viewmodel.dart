import 'package:edupot/data/repositories/student_service.dart';
import 'package:flutter/material.dart';
import 'package:edupot/data/models/leads_model.dart';

class StudentViewModel extends ChangeNotifier {
  List<Lead> _students = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Lead> get students => _students;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchStudents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _students = await StudentService().getStudents();
      _errorMessage = ''; // Reset error message on success
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
