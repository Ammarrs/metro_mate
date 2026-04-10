import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, email, name, profileImage];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // API may return _id as int (e.g. 123) or String — toString() handles both
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (profileImage != null) 'photo': profileImage,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}