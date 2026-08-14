class WorkerModel {
  final String id;
  final String name;
  final String phone;
  final String location;
  final List<String> skills;
  final String experience;
  final String description;
  final String? profileImage;
  final DateTime createdAt;

  WorkerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.skills,
    required this.experience,
    required this.description,
    this.profileImage,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'location': location,
      'skills': skills,
      'experience': experience,
      'description': description,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory WorkerModel.fromMap(Map<String, dynamic> map) {
    return WorkerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      experience: map['experience'] ?? '',
      description: map['description'] ?? '',
      profileImage: map['profileImage'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
