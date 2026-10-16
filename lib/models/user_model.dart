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

  /// Serialize ke JSON Map untuk disimpan ke local storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'university': university,
        'major': major,
        'teachSkillIds': teachSkillIds,
        'learnSkillIds': learnSkillIds,
        'availability': availability,
        'learningMode': learningMode,
        'rating': rating,
        'ratingCount': ratingCount,
      };

  /// Deserialize dari JSON Map yang dibaca dari local storage.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        university: json['university'] as String,
        major: json['major'] as String,
        teachSkillIds: List<String>.from(json['teachSkillIds'] as List),
        learnSkillIds: List<String>.from(json['learnSkillIds'] as List),
        availability: List<String>.from(json['availability'] as List),
        learningMode: json['learningMode'] as String,
        rating: (json['rating'] as num).toDouble(),
        ratingCount: json['ratingCount'] as int,
      );

  /// Membuat salinan UserModel dengan field yang bisa diubah (untuk Update).
  UserModel copyWith({
    String? id,
    String? name,
    String? university,
    String? major,
    List<String>? teachSkillIds,
    List<String>? learnSkillIds,
    List<String>? availability,
    String? learningMode,
    double? rating,
    int? ratingCount,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        university: university ?? this.university,
        major: major ?? this.major,
        teachSkillIds: teachSkillIds ?? this.teachSkillIds,
        learnSkillIds: learnSkillIds ?? this.learnSkillIds,
        availability: availability ?? this.availability,
        learningMode: learningMode ?? this.learningMode,
        rating: rating ?? this.rating,
        ratingCount: ratingCount ?? this.ratingCount,
      );
}