

import 'package:dio/dio.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
///the working service 
class ApiService {
  final Dio _dio = Dio();
 
  static const String baseUrl = 'https://esmagroup.online/edupot/api/v1';
  // Original fetchLeads method (keep this for backward compatibility if needed)
  Future<Map<String, dynamic>> fetchLeads({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        'https://esmagroup.online/edupot/api/v1/paginate',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        // Return the complete response data
        return {
          'leads': (response.data['leads'] as List)
              .map((lead) => Lead.fromJson(lead))
              .toList(),
          'total': response.data['total'] ?? 0,
          'current_page': response.data['current_page'] ?? 1,
          'last_page': response.data['last_page'] ?? 1,
        };
      } else {
        throw Exception('Failed to load leads');
      }
    } catch (e) {
      throw Exception('Failed to load leads: $e');
    }
  }
  // post

  Future<bool> addLead(Lead lead) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.post(
        'https://esmagroup.online/edupot/api/v1/leads-store',
        data: lead.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to add lead: $e');
    }
  }


  // Add new method for fetching colleges
  Future<Map<String, dynamic>> fetchColleges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        'https://esmagroup.online/edupot/api/v1/college-list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return {
            'colleges': data['colleges'],
            'logopath': data['logopath'],
            'brochurepath': data['brochurepath'],
          };
        } else {
          throw Exception(data['message'] ?? 'Failed to load colleges');
        }
      } else {
        throw Exception('Failed to load colleges: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching colleges: $e');
    }
  }

//auth
Future<UserModel> sendForgotPasswordEmail(String email) async {
    try {
      final response = await _dio.post(
        '$baseUrl/mail-id',
        queryParameters: {'email': email},
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return UserModel.fromJson(data['user']);
        }
        throw Exception(data['message'] ?? 'Failed to send OTP');
      }
      throw Exception('Failed to send OTP');
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }
  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        '$baseUrl/otp-check',
        queryParameters: {
          'email': email,
          'otp': otp,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return {
            'user': UserModel.fromJson(data['user']),
            'token': data['token'], // This token will be used for password update
          };
        }
        throw Exception(data['message'] ?? 'Failed to verify OTP');
      }
      throw Exception('Failed to verify OTP');
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  Future<bool> updatePassword(String token, String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        '$baseUrl/update-password',
        data: {
          'password': password,
          'confirm_password': confirmPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Use token from OTP verification
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == true;
      } else if (response.statusCode == 422) {
        final data = response.data;
        throw Exception(data['message'] ?? 'Validation failed');
      }
      throw Exception('Failed to update password');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        throw Exception(data['message'] ?? 'Validation failed');
      }
      throw Exception('Error updating password: ${e.message}');
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }
}
