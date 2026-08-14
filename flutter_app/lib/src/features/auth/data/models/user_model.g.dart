// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      nationalId: json['nationalId'] as String?,
      profilePicture: json['profilePicture'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      isVerified: json['isVerified'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nationalId': instance.nationalId,
      'profilePicture': instance.profilePicture,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isVerified': instance.isVerified,
      'isPremium': instance.isPremium,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.worker: 'worker',
  UserRole.business: 'business',
  UserRole.admin: 'admin',
};

WorkerProfileModel _$WorkerProfileModelFromJson(Map<String, dynamic> json) =>
    WorkerProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      certificates: (json['certificates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      portfolioImages: (json['portfolioImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tradeLicense: json['tradeLicense'] as String?,
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      workingRadius: (json['workingRadius'] as num).toDouble(),
      languagesSpoken: (json['languagesSpoken'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      completedJobs: (json['completedJobs'] as num?)?.toInt() ?? 0,
      selfieVerification: json['selfieVerification'] as String?,
    );

Map<String, dynamic> _$WorkerProfileModelToJson(WorkerProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'skills': instance.skills,
      'yearsOfExperience': instance.yearsOfExperience,
      'certificates': instance.certificates,
      'portfolioImages': instance.portfolioImages,
      'tradeLicense': instance.tradeLicense,
      'hourlyRate': instance.hourlyRate,
      'workingRadius': instance.workingRadius,
      'languagesSpoken': instance.languagesSpoken,
      'isAvailable': instance.isAvailable,
      'rating': instance.rating,
      'completedJobs': instance.completedJobs,
      'selfieVerification': instance.selfieVerification,
    };

BusinessProfileModel _$BusinessProfileModelFromJson(
        Map<String, dynamic> json) =>
    BusinessProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      companyName: json['companyName'] as String,
      companyLogo: json['companyLogo'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      address: json['address'] as String?,
      employeeCount: (json['employeeCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$BusinessProfileModelToJson(
        BusinessProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'companyName': instance.companyName,
      'companyLogo': instance.companyLogo,
      'registrationNumber': instance.registrationNumber,
      'address': instance.address,
      'employeeCount': instance.employeeCount,
      'description': instance.description,
    };
