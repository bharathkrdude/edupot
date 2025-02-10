class StaffProfile {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String image;
  final String imagePath;

  StaffProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.image,
    required this.imagePath,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) {
    return StaffProfile(
      id: json["staffes"]["id"],
      name: json["staffes"]["name"],
      phone: json["staffes"]["phone"],
      email: json["staffes"]["email"],
      image: json["staffes"]["image"],
      imagePath: json["imagepath"],
    );
  }
}
