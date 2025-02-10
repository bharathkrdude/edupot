class College {
  final int id;
  final String name;
  final String university;
  final String address;
  final String about;
  final String? logo;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final int updatedBy;
  final List<BrochureImage> brochurerelated;
  final List<FeesImage> feesrelated;
  final String logoPath;
  final String brochureImagePath;
  final String feesImagePath;

  College({
    required this.id,
    required this.name,
    required this.university,
    required this.address,
    required this.about,
    this.logo,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.brochurerelated,
    required this.feesrelated,
    required this.logoPath,
    required this.brochureImagePath,
    required this.feesImagePath,
  });

  String? get fullLogoUrl => logo != null ? '$logoPath$logo' : null;

  factory College.fromJson(Map<String, dynamic> json, String logoPath, String brochureImagePath, String feesImagePath) {
    return College(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown College',
      university: json['university'] ?? 'Unknown University',
      address: json['address'] ?? 'No Address Provided',
      about: json['about'] ?? 'No About Information',
      logo: json['logo'], // Nullable
      location: json['location'] ?? 'Unknown Location',
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      createdBy: json['created_by'] ?? 0,
      updatedBy: json['updated_by'] ?? 0,
      brochurerelated: (json['brochurerelated'] as List?)?.map((image) => BrochureImage.fromJson(image)).toList() ?? [],
      feesrelated: (json['feesrelated'] as List?)?.map((fees) => FeesImage.fromJson(fees)).toList() ?? [],
      logoPath: logoPath,
      brochureImagePath: brochureImagePath,
      feesImagePath: feesImagePath,
    );
  }

  /// Helper method to safely parse DateTime from JSON
  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now(); // Default to current date if null
    try {
      return DateTime.parse(date);
    } catch (e) {
      return DateTime.now(); // Default fallback
    }
  }
}


class BrochureImage {
  final int id;
  final int collegeId;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  BrochureImage({
    required this.id,
    required this.collegeId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrochureImage.fromJson(Map<String, dynamic> json) {
    return BrochureImage(
      id: json['id'],
      collegeId: json['college_id'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class FeesImage {
  final int id;
  final int collegeId;
  final String fees;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeesImage({
    required this.id,
    required this.collegeId,
    required this.fees,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeesImage.fromJson(Map<String, dynamic> json) {
    return FeesImage(
      id: json['id'],
      collegeId: json['college_id'],
      fees: json['fees'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
