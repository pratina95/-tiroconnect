// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterCustomerRequest _$RegisterCustomerRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterCustomerRequest(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      nationalId: json['nationalId'] as String?,
      profilePicture: json['profilePicture'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RegisterCustomerRequestToJson(
        RegisterCustomerRequest instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nationalId': instance.nationalId,
      'profilePicture': instance.profilePicture,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

RegisterWorkerRequest _$RegisterWorkerRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterWorkerRequest(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      nationalId: json['nationalId'] as String?,
      profilePicture: json['profilePicture'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
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
    );

Map<String, dynamic> _$RegisterWorkerRequestToJson(
        RegisterWorkerRequest instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nationalId': instance.nationalId,
      'profilePicture': instance.profilePicture,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'skills': instance.skills,
      'yearsOfExperience': instance.yearsOfExperience,
      'certificates': instance.certificates,
      'portfolioImages': instance.portfolioImages,
      'tradeLicense': instance.tradeLicense,
      'hourlyRate': instance.hourlyRate,
      'workingRadius': instance.workingRadius,
      'languagesSpoken': instance.languagesSpoken,
    };

RegisterBusinessRequest _$RegisterBusinessRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterBusinessRequest(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      nationalId: json['nationalId'] as String?,
      profilePicture: json['profilePicture'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      companyName: json['companyName'] as String,
      companyLogo: json['companyLogo'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$RegisterBusinessRequestToJson(
        RegisterBusinessRequest instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'nationalId': instance.nationalId,
      'profilePicture': instance.profilePicture,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'companyName': instance.companyName,
      'companyLogo': instance.companyLogo,
      'registrationNumber': instance.registrationNumber,
      'address': instance.address,
    };
