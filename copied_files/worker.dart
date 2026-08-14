class Worker {
  final String id;
  final String name;
  final String phone;
  final String location;
  final List<String> skills;
  final String experience;
  final String description;
  final String? profileImage;
  final DateTime createdAt;

  Worker({
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
}
