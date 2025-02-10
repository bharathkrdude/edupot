import 'package:edupot/core/services/api_service.dart';
import 'package:edupot/data/models/leads_model.dart';
import 'package:flutter/material.dart';


class LeadProvider with ChangeNotifier {
  final ApiService apiService;

  LeadProvider({required this.apiService});

  Future<bool> addLead(Lead lead) async {
    return await apiService.addLead(lead);
  }

  Future<Map<String, dynamic>> fetchLeads({
    int page = 1,
    int perPage = 20,
    String? stage, // Optional
    String? fromDate, // Optional
    String? toDate, // Optional
  }) async {
    return await apiService.fetchLeads(
      page: page,
      perPage: perPage,
      stage: stage,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
