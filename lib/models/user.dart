class User {
  int? id;
  String email;
  String password;
  bool isActive;
  String role = 'user'; // Default role
  DateTime createdAt;
  DateTime updatedAt;
  String? image;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.role,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.image,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role' : role,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      isActive: map['is_active'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      image: map['image'],
    );
  }

  get profileImage => image ?? 'assets/images/default_profile.png';

   User copyWith({
    int? id,
    String? email,
    String? password,
    String? role,
    String? image,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
    );
  }
}
