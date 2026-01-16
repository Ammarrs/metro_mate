import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profileImage; // NEW: Add profile image URL

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage, // NEW: Optional profile image
  });

  @override
  List<Object?> get props => [id, email, name, profileImage];

  // From JSON (for API responses)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      email: json['email'],
      name: json['name'],
      profileImage: json['profileImage'] ?? json['profile_image'], // NEW
    );
  }

  // To JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      if (profileImage != null) 'profileImage': profileImage, // NEW
    };
  }

  // Copy with method for updates
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage, // NEW
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage, // NEW
    );
  }
}