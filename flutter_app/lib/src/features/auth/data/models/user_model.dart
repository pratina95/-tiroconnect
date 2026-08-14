import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum UserRole { customer, worker, business, admin }

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? nationalId;
  final String? profilePicture;
  final double? latitude;
  final double? longitude;
  final UserRole role;
  final bool isVerified;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.nationalId,
    this.profilePicture,
    this.latitude,
    this.longitude,
    required this.role,
    this.isVerified = false,
    this.isPremium = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        email,
        nationalId,
        profilePicture,
        latitude,
        longitude,
        role,
        isVerified,
        isPremium,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class WorkerProfileModel extends Equatable {
  final String id;
  final String userId;
  final List<String> skills;
  final int yearsOfExperience;
  final List<String> certificates;
  final List<String> portfolioImages;
  final String? tradeLicense;
  final double hourlyRate;
  final double workingRadius;
  final List<String> languagesSpoken;
  final bool isAvailable;
  final double rating;
  final int completedJobs;
  final String? selfieVerification;

  const WorkerProfileModel({
    required this.id,
    required this.userId,
    required this.skills,
    required this.yearsOfExperience,
    required this.certificates,
    required this.portfolioImages,
    this.tradeLicense,
    required this.hourlyRate,
    required this.workingRadius,
    required this.languagesSpoken,
    this.isAvailable = true,
    this.rating = 0.0,
    this.completedJobs = 0,
    this.selfieVerification,
  });

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$WorkerProfileModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        skills,
        yearsOfExperience,
        certificates,
        portfolioImages,
        tradeLicense,
        hourlyRate,
        workingRadius,
        languagesSpoken,
        isAvailable,
        rating,
        completedJobs,
        selfieVerification,
      ];
}

@JsonSerializable()
class BusinessProfileModel extends Equatable {
  final String id;
  final String userId;
  final String companyName;
  final String? companyLogo;
  final String? registrationNumber;
  final String? address;
  final int employeeCount;
  final String? description;

  const BusinessProfileModel({
    required this.id,
    required this.userId,
    required this.companyName,
    this.companyLogo,
    this.registrationNumber,
    this.address,
    this.employeeCount = 0,
    this.description,
  });

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessProfileModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        companyName,
        companyLogo,
        registrationNumber,
        address,
        employeeCount,
        description,
      ];
}
