import 'dart:convert';
import 'package:edupot/data/models/staff_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StaffProfileProvider with ChangeNotifier {
  StaffProfile? _staffProfile;
  bool _isLoading = false;

  StaffProfile? get staffProfile => _staffProfile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Error: Bearer token is not available.');
        _isLoading = false;
        notifyListeners();
        return;
      }

      var response = await http.get(
        Uri.parse('https://edupotstudy.com/api/v1/staff-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData["status"] == true && jsonData["staffes"] != null) {
          _staffProfile = StaffProfile.fromJson(jsonData);
        } else {
          print("Error: Invalid response format.");
        }
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
