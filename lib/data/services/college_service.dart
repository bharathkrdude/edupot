
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollegeApiService extends GetxService {
  static const String baseUrl = 'https://edupotstudy.com/api/v1';
  final _dio = dio.Dio();

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  
  Future<dio.Response> fetchColleges() async {
    final token = await getToken();
    if (token == null) throw Exception('Token not found');

    return await _dio.get(
      '$baseUrl/college-list',
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
  }
}
