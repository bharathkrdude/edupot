import 'package:edupot/core/services/api_service.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:flutter/material.dart';

class LeadProvider with ChangeNotifier {
  final ApiService apiService;

  LeadProvider({required this.apiService});

  Future<bool> addLead(Lead lead) async {
    return await apiService.addLead(lead);
    
  }
  // Updated fetchLeads with pagination parameters
 Future<Map<String, dynamic>> fetchLeads({
    int page = 1,
    int perPage = 10,
  }) async {
    return await apiService.fetchLeads(
      page: page,
      perPage: perPage,
    );
  }
}
