class UserModel {
  final String id;
  final String? email;
  final String? fullName;

  UserModel({required this.id, this.email, this.fullName});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String?,
      fullName: map['full_name'] as String?,
    );
  }
}
