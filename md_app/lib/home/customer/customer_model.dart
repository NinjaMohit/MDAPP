class CustomerModel {
  final int? id;
  final String? societyName;
  final String? buildingName;
  final String? flatNo;
  final String? customerName;
  final String? customerMobile;
  final String? abbreviation;
  final int? isActive;
  final String? qrData;
  final String? createdAt;
  final String? updatedAt;

  CustomerModel({
    this.id,
    required this.societyName,
    required this.buildingName,
    required this.flatNo,
    required this.customerName,
    required this.customerMobile,
    required this.abbreviation,
    required this.isActive,
    this.qrData,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'societyName': societyName,
        'buildingName': buildingName,
        'flatNo': flatNo,
        'customerName': customerName,
        'customerMobile': customerMobile,
        'abbreviation': abbreviation,
        'isActive': isActive,
        'qrData': qrData,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int?,
      societyName: json['societyName'] as String?,
      buildingName: json['buildingName'] as String?,
      flatNo: json['flatNo'] as String?,
      customerName: json['customerName'] as String?,
      customerMobile: json['customerMobile'] as String?,
      abbreviation: json['abbreviation'] as String?,
      isActive: json['isActive'] as int?,
      qrData: json['qrData'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }
}
