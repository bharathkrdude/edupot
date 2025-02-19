import 'dart:convert';
import 'dart:io';
import 'package:edupot/data/models/staff_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StaffProfileProvider with ChangeNotifier {
  StaffProfile? _staffProfile;
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _updateError;

  StaffProfile? get staffProfile => _staffProfile;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get updateError => _updateError;

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

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
    File? imageFile,
  }) async {
    if (_staffProfile == null) {
      _updateError = 'Staff profile not loaded';
      return false;
    }

    final staffId = _staffProfile!.id;
    _isUpdating = true;
    _updateError = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _updateError = 'Bearer token is not available';
        _isUpdating = false;
        notifyListeners();
        return false;
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://edupotstudy.com/api/v1/staff-update/$staffId'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone'] = phone;

      // Add image file if provided
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        
        if (jsonData["status"] == true) {
          // Update the local staff profile data
          await fetchProfile();
          _isUpdating = false;
          notifyListeners();
          return true;
        } else {
          _updateError = jsonData["message"] ?? "Profile update failed";
        }
      } else {
        _updateError = "Error: ${response.statusCode} - ${response.reasonPhrase}";
      }
    } catch (e) {
      _updateError = "Error updating profile: $e";
      print(_updateError);
    }

    _isUpdating = false;
    notifyListeners();
    return false;
  }
}