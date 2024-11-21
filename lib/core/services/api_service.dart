// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants/api_constants.dart';

// class ApiService {
//   final Dio _dio;

//   // Initialize Dio with base options including the baseUrl and default headers
//   ApiService()
//       : _dio = Dio(BaseOptions(
//           baseUrl: ApiConstants.baseUrl,
//           headers: {'Accept': 'application/json'},
//         ));

//   // Add the Bearer Token from SharedPreferences to the request header
//   Future<void> addBearerToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//     if (token != null) {
//       _dio.options.headers['Authorization'] = 'Bearer $token';
//     }
//   }

//   // Method to perform GET request, automatically adding the token to the header
//   Future<Response> get(String endpoint) async {
//     await addBearerToken();  // Ensure token is added before making the request
//     return await _dio.get(endpoint);  // Make the GET request
//   }
// }

import 'package:dio/dio.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();

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
}
