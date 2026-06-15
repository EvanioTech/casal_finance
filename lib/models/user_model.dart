class UserModel {
  final String uid;
  final String email;
  final String name;
  final String coupleId; // Link users who share the same finances

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.coupleId,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      coupleId: data['coupleId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'coupleId': coupleId,
    };
  }
}
