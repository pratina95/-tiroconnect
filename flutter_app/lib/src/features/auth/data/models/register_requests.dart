import 'package:json_annotation/json_annotation.dart';

part 'register_requests.g.dart';

@JsonSerializable()
class RegisterCustomerRequest {
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? nationalId;
  final String? profilePicture;
  final double? latitude;
  final double? longitude;

  RegisterCustomerRequest({
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.nationalId,
    this.profilePicture,
    this.latitude,
    this.longitude,
  });

  factory RegisterCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterCustomerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterCustomerRequestToJson(this);
}

@JsonSerializable()
class RegisterWorkerRequest {
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? nationalId;
  final String? profilePicture;
  final double? latitude;
  final double? longitude;
  final List<String> skills;
  final int yearsOfExperience;
  final List<String> certificates;
  final List<String> portfolioImages;
  final String? tradeLicense;
  final double hourlyRate;
  final double workingRadius;
  final List<String> languagesSpoken;

  RegisterWorkerRequest({
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.nationalId,
    this.profilePicture,
    this.latitude,
    this.longitude,
    required this.skills,
    required this.yearsOfExperience,
    required this.certificates,
    required this.portfolioImages,
    this.tradeLicense,
    required this.hourlyRate,
    required this.workingRadius,
    required this.languagesSpoken,
  });

  factory RegisterWorkerRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterWorkerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterWorkerRequestToJson(this);
}

@JsonSerializable()
class RegisterBusinessRequest {
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? nationalId;
  final String? profilePicture;
  final double? latitude;
  final double? longitude;
  final String companyName;
  final String? companyLogo;
  final String? registrationNumber;
  final String? address;

  RegisterBusinessRequest({
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.nationalId,
    this.profilePicture,
    this.latitude,
    this.longitude,
    required this.companyName,
    this.companyLogo,
    this.registrationNumber,
    this.address,
  });

  factory RegisterBusinessRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterBusinessRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterBusinessRequestToJson(this);
}
