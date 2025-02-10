class DashboardModel {
  final bool status;
  final String message;
  final Map<String, int> leadsCount;
  final int totalLeads;
  final List<String> bannerImages;

  DashboardModel({
    required this.status,
    required this.message,
    required this.leadsCount,
    required this.totalLeads,
    required this.bannerImages,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    // Handle leadsCount parsing
    Map<String, int> parsedLeadsCount = {};
    if (json['leadsCount'] is Map) {
      final leadsCountData = json['leadsCount'] as Map<String, dynamic>;
      leadsCountData.forEach((key, value) {
        parsedLeadsCount[key] = value is int ? value : 0;
      });
    }

    // Handle bannerImages parsing
    List<String> parsedBannerImages = [];
    if (json['bannerImages'] is List) {
      parsedBannerImages = (json['bannerImages'] as List)
          .map((e) => e.toString())
          .toList();
    }

    return DashboardModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      leadsCount: parsedLeadsCount,
      totalLeads: json['totalLeads'] ?? 0,
      bannerImages: parsedBannerImages,
    );
  }

  // Optional: Add a method to safely get lead count
  int getLeadCount(String category) {
    return leadsCount[category] ?? 0;
  }
}
