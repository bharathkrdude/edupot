class Lead {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String parentName;
  final String parentPhone;
  final int ownerId;
  final String stream;
  final String status;
  final String stage;
  final String remark;
  final int priority;
  final DateTime createdAt;
  final int? createdBy;
  final DateTime updatedAt;
  final int? updatedBy;
  final DateTime? deletedAt;

  Lead({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.parentName,
    required this.parentPhone,
    required this.ownerId,
    required this.stream,
    required this.status,
    required this.stage,
    required this.remark,
    required this.priority,
    required this.createdAt,
    this.createdBy,
    required this.updatedAt,
    this.updatedBy,
    this.deletedAt,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      parentName: json['parent_name'],
      parentPhone: json['parent_phone'],
      ownerId: json['owner_id'],
      stream: json['stream'],
      status: json['status'],
      stage: json['stage'],
      remark: json['remark'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
      updatedAt: DateTime.parse(json['updated_at']),
      updatedBy: json['updated_by'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }
}
