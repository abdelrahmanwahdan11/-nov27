import 'dart:convert';

class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.gender,
    required this.goal,
    required this.fitnessLevel,
  });

  final String id;
  final String name;
  final String email;
  final int age;
  final double heightCm;
  final double weightKg;
  final String gender;
  final String goal;
  final String fitnessLevel;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'gender': gender,
        'goal': goal,
        'fitnessLevel': fitnessLevel,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        age: json['age'] as int,
        heightCm: (json['heightCm'] as num).toDouble(),
        weightKg: (json['weightKg'] as num).toDouble(),
        gender: json['gender'] as String,
        goal: json['goal'] as String,
        fitnessLevel: json['fitnessLevel'] as String,
      );

  static UserProfile? fromPrefsString(String? data) {
    if (data == null) return null;
    return UserProfile.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  String toPrefsString() => json.encode(toJson());
}
