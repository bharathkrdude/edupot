

class UserModel {
  final int id;
  final String name;
  final String userType;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.userType,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      userType: json['user_type'],
      email: json['email'],
    );
  }
}
