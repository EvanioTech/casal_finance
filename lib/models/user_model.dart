class UserModel {
  final String uid;
  final String email;
  final String name;
  final String coupleId; // Link users who share the same finances
  final String? photoBase64;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool darkMode;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.coupleId,
    this.photoBase64,
    this.pushEnabled = true,
    this.emailEnabled = false,
    this.darkMode = true,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      coupleId: data['coupleId'] ?? '',
      photoBase64: data['photoBase64'],
      pushEnabled: data['pushEnabled'] ?? true,
      emailEnabled: data['emailEnabled'] ?? false,
      darkMode: data['darkMode'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'coupleId': coupleId,
      'photoBase64': photoBase64,
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'darkMode': darkMode,
    };
  }
}
