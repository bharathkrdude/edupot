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

  Future<List<Lead>> fetchLeads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await _dio.get(
        'https://esmagroup.online/edupot/api/v1/leads-list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['leads'];
        return data.map((lead) => Lead.fromJson(lead)).toList();
      } else {
        throw Exception('Failed to load leads');
      }
    } catch (e) {
      throw Exception('Failed to load leads: $e');
    }
  }
}
