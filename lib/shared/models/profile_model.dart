import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileModel {
  final String id;
  final String? userId;
  final String fullName;
  final String gender;
  final DateTime dateOfBirth;
  final String religion;
  final String? caste;
  final String motherTongue;
  final String city;
  final String profession;
  final String? education;
  final int? annualIncomeLpa;
  final String? aboutMe;
  final String? profilePhotoUrl;
  final List<String> photoUrls;
  final bool isVerified;
  final String plan;
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    this.userId,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.religion,
    this.caste,
    required this.motherTongue,
    required this.city,
    required this.profession,
    this.education,
    this.annualIncomeLpa,
    this.aboutMe,
    this.profilePhotoUrl,
    this.photoUrls = const [],
    this.isVerified = false,
    this.plan = 'free',
    this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      religion: json['religion'],
      caste: json['caste'],
      motherTongue: json['mother_tongue'],
      city: json['city'],
      profession: json['profession'],
      education: json['education'],
      annualIncomeLpa: json['annual_income_lpa'],
      aboutMe: json['about_me'],
      profilePhotoUrl: json['profile_photo_url'],
      photoUrls: List<String>.from(json['photo_urls'] ?? []),
      isVerified: json['is_verified'] ?? false,
      plan: json['plan'] ?? 'free',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'gender': gender,
      'date_of_birth': dateOfBirth.toIso8601String().split('T')[0],
      'religion': religion,
      'caste': caste,
      'mother_tongue': motherTongue,
      'city': city,
      'profession': profession,
      'education': education,
      'annual_income_lpa': annualIncomeLpa,
      'about_me': aboutMe,
      'profile_photo_url': profilePhotoUrl,
      'photo_urls': photoUrls,
      'is_verified': isVerified,
      'plan': plan,
    };
  }
}
