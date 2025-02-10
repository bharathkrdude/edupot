import 'package:edupot/core/services/api_service.dart';
import 'package:edupot/data/models/college_model.dart';
import 'package:flutter/foundation.dart';

class CollegeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<College> _colleges = [];
  List<College> _filteredColleges = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  String _logoPath = '';
  String _brochureImagePath = '';
  String _feesImagePath = '';

  List<College> get colleges => _searchQuery.isEmpty ? _colleges : _filteredColleges;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get logoPath => _logoPath;
  String get brochureImagePath => _brochureImagePath;
  String get feesImagePath => _feesImagePath;

  Future<void> fetchColleges() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await _apiService.fetchColleges();
      
      if (response['status'] == true) {
        _logoPath = response['logopath'];
        _brochureImagePath = response['brochureimagepath'];
        _feesImagePath = response['feesimagepath'];
        
        _colleges = (response['colleges'] as List).map((json) => 
          College.fromJson(
            json, 
            _logoPath, 
            _brochureImagePath,
            _feesImagePath,
          )
        ).toList();
        
        _applySearch();
      } else {
        _error = response['message'] ?? 'Failed to fetch colleges';
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void searchColleges(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredColleges = [];
      return;
    }

    _filteredColleges = _colleges.where((college) {
      return college.name.toLowerCase().contains(_searchQuery) ||
             college.university.toLowerCase().contains(_searchQuery) ||
             college.address.toLowerCase().contains(_searchQuery) ||
             college.location.toLowerCase().contains(_searchQuery);
    }).toList();
  }
}
