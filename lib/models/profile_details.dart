class ProfileDetails {
  const ProfileDetails({
    required this.name,
    required this.university,
    required this.major,
  });

  final String name;
  final String university;
  final String major;

  factory ProfileDetails.fromMap(Map<String, dynamic> data) {
    final name = data['name'];
    final university = data['university'] ?? '';
    final major = data['major'] ?? '';
    if (name is! String || university is! String || major is! String) {
      throw const FormatException('Data profil tidak lengkap.');
    }
    return ProfileDetails(
      name: name,
      university: university,
      major: major,
    );
  }

  Map<String, dynamic> toEditableFields() => {
        'name': name.trim(),
        'university': university.trim(),
        'major': major.trim(),
      };

  Map<String, dynamic> toNewDocument({
    required String uid,
    required String email,
  }) =>
      {
        'id': uid,
        'email': email,
        ...toEditableFields(),
        'teachSkillIds': <String>[],
        'learnSkillIds': <String>[],
        'availability': <String>[],
        'learningMode': 'online',
        'rating': 0,
        'ratingCount': 0,
      };
}
