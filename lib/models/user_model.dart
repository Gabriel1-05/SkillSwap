class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.university,
    required this.major,
    required this.teachSkillIds,
    required this.learnSkillIds,
    required this.availability,
    required this.learningMode,
    required this.rating,
    required this.ratingCount,
  });

  final String id;
  final String name;
  final String university;
  final String major;
  final List<String> teachSkillIds;
  final List<String> learnSkillIds;
  final List<String> availability;
  final String learningMode;
  final double rating;
  final int ratingCount;
}