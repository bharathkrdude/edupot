
import 'package:edupot/core/services/api_service.dart';
import 'package:edupot/data/models/user.dart';
import 'package:flutter/foundation.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  String _error = '';
  UserModel? _user;
  String? _token;

  bool get isLoading => _isLoading;
  String get error => _error;
  UserModel? get user => _user;
  String? get token => _token;

  Future<bool> sendOtp(String email) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _user = await _apiService.sendForgotPasswordEmail(email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final result = await _apiService.verifyOtp(email, otp);
      _user = result['user'] as UserModel;
      _token = result['token'] as String;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword(String password, String confirmPassword) async {
    if (_token == null) {
      _error = 'No authentication token found';
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final success = await _apiService.updatePassword(_token!, password, confirmPassword);
      
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
