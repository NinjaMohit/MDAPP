class HistoryModel {
  final int? id;
  final int customerId;
  final int createdById;
  final String createdAt;

  HistoryModel({
    this.id,
    required this.customerId,
    required this.createdById,
    required this.createdAt,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      customerId: map['customerId'],
      createdById: map['createdById'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'createdById': createdById,
      'createdAt': createdAt,
    };
  }
}
