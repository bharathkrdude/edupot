import 'package:dio/dio.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:edupot/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

  static const String baseUrl = 'https://edupotstudy.com/api/v1';
  Future<Map<String, dynamic>> fetchLeads({
    int page = 1,
    int perPage = 20,
    String? stage,
    String? fromDate,
    String? toDate,
    
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.post(
        'https://edupotstudy.com/api/v1/leads-multi',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: {
          'page': page,
          'per_page': perPage,
          'stage': stage,
          'from_date': fromDate,
          'to_date': toDate,
          
        },
      );

      if (response.statusCode == 200) {
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

  Future<bool> addLead(Lead lead) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.post(
        'https://edupotstudy.com/api/v1/leads-store',
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

 Future<Map<String, dynamic>> fetchColleges() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await _dio.get(
      'https://edupotstudy.com/api/v1/college-list',
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
          'status': data['status'],
          'message': data['message'],
          'colleges': data['colleges'],
          'logopath': data['logopath'],
          'brochureimagepath': data['brochureimagepath'],
          'feesimagepath': data['feesimagepath'],
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
            'token': data['token'],
          };
        }
        throw Exception(data['message'] ?? 'Failed to verify OTP');
      }
      throw Exception('Failed to verify OTP');
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  Future<bool> updatePassword(
      String token, String password, String confirmPassword) async {
    try {
      final response = await _dio.post(
        '$baseUrl/update-password',
        data: {
          'password': password,
          'confirm_password': confirmPassword,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
 
  Future<Map<String, dynamic>> fetchDashboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        '$baseUrl/dashboard',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}
