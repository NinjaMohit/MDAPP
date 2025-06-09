class UserModel {
  int? id;
  String username;
  String password;
  int isActive;
  int isAdmin;
  String createdAt;
  String updatedAt;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    this.isActive = 0,
    this.isAdmin = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        username: map['username'],
        password: map['password'],
        isActive: map['isActive'],
        isAdmin: map['isAdmin'],
        createdAt: map['createdAt'],
        updatedAt: map['updatedAt'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'isActive': isActive,
        'isAdmin': isAdmin,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
