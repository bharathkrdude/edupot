import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edupot/data/models/leads_model.dart';

class StudentService {
  final Dio _dio = Dio();

  Future<List<Lead>> getStudents() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // Fetch token from SharedPreferences

      if (token == null) {
        throw Exception('No token found');
      }

      final response = await _dio.get(
        'https://esmagroup.online/edupot/api/v1/leads-list',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("API Response: ${response.data}");  // Log the response

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];  // Assuming the response has 'data' key
        if (data.isNotEmpty) {
          return data.map((e) => Lead.fromJson(e)).toList();
        } else {
          throw Exception('No students available');
        }
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }
}
