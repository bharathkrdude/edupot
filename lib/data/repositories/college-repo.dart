// // lib/services/college_repository.dart



// import 'package:edupot/data/models/college_model.dart';
// import 'package:edupot/data/services/college_service.dart';

// class CollegeRepository {
//   final CollegeApiService _apiService;

//   CollegeRepository(this._apiService);

//   Future<List<College>> getColleges() async {
//     try {
//       // Changed to match the API service method name
//       final response = await _apiService.fetchColleges();
      
//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data['status'] == true) {
//           return (data['colleges'] as List)
//               .map((json) => College.fromJson(json))
//               .toList();
//         }
//       }
//       throw Exception('Failed to load colleges');
//     } catch (e) {
//       throw Exception('Failed to load colleges: $e');
//     }
//   }
// }
