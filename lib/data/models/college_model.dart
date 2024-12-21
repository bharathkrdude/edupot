class College {
  final int id;
  final String name;
  final String university;
  final String address;
  final String about;
  final String logo;
  final List<CollegeImage> images;
  final String logoPath;
  final String brochurePath;

  College({
    required this.id,
    required this.name,
    required this.university,
    required this.address,
    required this.about,
    required this.logo,
    required this.images,
    required this.logoPath,
    required this.brochurePath,
  });

  String get fullLogoUrl => '$logoPath$logo';
  
  factory College.fromJson(Map<String, dynamic> json, String logoPath, String brochurePath) {
    return College(
      id: json['id'],
      name: json['name'],
      university: json['university'],
      address: json['address'],
      about: json['about'],
      logo: json['logo'],
      images: (json['images'] as List)
          .map((image) => CollegeImage.fromJson(image))
          .toList(),
      logoPath: logoPath,
      brochurePath: brochurePath,
    );
  }
}

class CollegeImage {
  final int id;
  final int brochureId;
  final String image;

  CollegeImage({
    required this.id,
    required this.brochureId,
    required this.image,
  });

  factory CollegeImage.fromJson(Map<String, dynamic> json) {
    return CollegeImage(
      id: json['id'],
      brochureId: json['brochure_id'],
      image: json['image'],
    );
  }
}
