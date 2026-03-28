class AppUser {
  final String id;
  final String email;
  final String contact;

  AppUser({
    required this.id,
    required this.email,
    required this.contact,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      contact: map['contact'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'contact': contact,
    };
  }
}