import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/models/dashboard_model.dart';
import '../core/services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  DashboardModel? _dashboardData;
  bool _isLoading = false;
  String _error = '';

  DashboardModel? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String get error => _error;
  List<String> get bannerImages => _dashboardData?.bannerImages ?? [];
  int get totalLeads => _dashboardData?.totalLeads ?? 0;
  Map<String, int> get leadsCount => _dashboardData?.leadsCount ?? {};
  List<String> get categories => _dashboardData?.leadsCount.keys.toList() ?? [];

  Future<void> fetchDashboardData() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await _apiService.fetchDashboard();

      _dashboardData = DashboardModel.fromJson(response);
      _error = '';
      
    } catch (e) {
      _error = e.toString();
      _dashboardData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    return fetchDashboardData();
  }

  // Get leads count for specific category
  int getLeadsCountForCategory(String category) {
    return _dashboardData?.leadsCount[category] ?? 0;
  }

  // Calculate percentage for category
  double getCategoryPercentage(String category) {
    if (totalLeads == 0) return 0;
    final categoryCount = getLeadsCountForCategory(category);
    return (categoryCount / totalLeads) * 100;
  }

  // Get color for category
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'commerce':
        return Colors.blue;
      case 'science':
        return Colors.green;
      case 'others':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Get light color for category
  Color getCategoryLightColor(String category) {
    switch (category.toLowerCase()) {
      case 'commerce':
        return Colors.blue.shade100;
      case 'science':
        return Colors.green.shade100;
      case 'others':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  // Get icon for category
  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'commerce':
        return Icons.business_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'others':
        return Icons.menu_book_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  // Check if data is available
  bool get hasData => _dashboardData != null && !_isLoading && _error.isEmpty;

  // Check if any category has data
  bool get hasCategoryData => totalLeads > 0;

  // Get formatted percentage for display
  String getFormattedPercentage(String category) {
    final percentage = getCategoryPercentage(category);
    return percentage > 0 ? '${percentage.toStringAsFixed(1)}%' : '0%';
  }

  // Get progress value for category (0 to 1)
  double getProgressValue(String category) {
    final percentage = getCategoryPercentage(category);
    if (percentage.isNaN || percentage.isInfinite) return 0;
    return percentage / 100;
  }

  // Get category display name
  String getCategoryDisplayName(String category) {
    return '${category.substring(0, 1).toUpperCase()}${category.substring(1)} Category';
  }

  // Get stats for category
  Map<String, dynamic> getCategoryStats(String category) {
    final count = getLeadsCountForCategory(category);
    final percentage = getCategoryPercentage(category);
    
    return {
      'count': count,
      'percentage': percentage,
      'displayName': getCategoryDisplayName(category),
      'color': getCategoryColor(category),
      'icon': getCategoryIcon(category),
      'lightColor': getCategoryLightColor(category),
    };
  }

  // Get pie chart sections
  List<PieChartSectionData> getPieChartSections() {
    if (!hasCategoryData) {
      return [
        PieChartSectionData(
          value: 100,
          title: '0%',
          color: Colors.grey.shade300,
          radius: 60,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ];
    }

    return categories.map((category) {
      final percentage = getCategoryPercentage(category);
      return PieChartSectionData(
        value: percentage > 0 ? percentage : 0,
        title: percentage > 0 ? '${percentage.toStringAsFixed(1)}%' : '',
        color: getCategoryColor(category),
        radius: 60,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }

  // Get stats card data
  List<Map<String, dynamic>> getStatsCardData() {
    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Total Leads',
        'value': totalLeads.toString(),
        'icon': Icons.people_outline,
        'color': Colors.blue.shade100,
      },
    ];

    for (final category in categories) {
      stats.add({
        'title': category,
        'value': getLeadsCountForCategory(category).toString(),
        'icon': getCategoryIcon(category),
        'color': getCategoryLightColor(category),
      });
    }

    return stats;
  }

  // Reset state
  void resetState() {
    _dashboardData = null;
    _isLoading = false;
    _error = '';
    notifyListeners();
  }

  // Dispose
  @override
  void dispose() {
    resetState();
    super.dispose();
  }
}
