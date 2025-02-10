class Lead {
   int id;
   String name;
   String address;
   String phone;
   String? email;
   String parentName;
   String parentPhone;
   int? ownerId;
   String stream;
  String? customStream;
   String status;
   String stage;
   String remark;
   String? course;
  
   DateTime createdAt;
   int? createdBy;
   DateTime updatedAt;
  int? updatedBy;
   DateTime? deletedAt;

  Lead({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.email,
    required this.parentName,
    required this.parentPhone,
    this.ownerId,
    required this.stream,
    this.customStream,
    required this.status,
    required this.stage,
    required this.remark,
    this.course,
    
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
      customStream: json['custom_stream'],
      status: json['status'],
      stage: json['stage'],
      remark: json['remark'],
      course: json['course'],
     
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
      updatedAt: DateTime.parse(json['updated_at']),
      updatedBy: json['updated_by'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'parent_name': parentName,
      'parent_phone': parentPhone,
      'stream': stream,
      'status': status,
      'stage': stage,
      'course': course,
      'remark': remark,
     
    };

    if (stream == "Other" && customStream != null) {
      data['custom_stream'] = customStream;
    }

    data.removeWhere((key, value) => value == null);

    return data;
  }
}
