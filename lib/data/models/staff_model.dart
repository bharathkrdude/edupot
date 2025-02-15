class Staff {
  final String name;

  Staff({required this.name});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      name: json['name'] ?? '',
    );
  }
}

class StaffResponse {
  final bool status;
  final String message;
  final List<Staff> staffs;

  StaffResponse({required this.status, required this.message, required this.staffs});

  factory StaffResponse.fromJson(Map<String, dynamic> json) {
    return StaffResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      staffs: (json['staffs'] as List<dynamic>)
          .map((staffJson) => Staff.fromJson(staffJson))
          .toList(),
    );
  }
}
