class RequestCandidate {
  const RequestCandidate({
    required this.id,
    required this.name,
    required this.teachSkillIds,
  });

  final String id;
  final String name;
  final List<String> teachSkillIds;

  /// Serialize ke JSON Map untuk disimpan ke local storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'teachSkillIds': teachSkillIds,
      };

  /// Deserialize dari JSON Map yang dibaca dari local storage.
  factory RequestCandidate.fromJson(Map<String, dynamic> json) =>
      RequestCandidate(
        id: json['id'] as String,
        name: json['name'] as String,
        teachSkillIds: List<String>.from(json['teachSkillIds'] as List),
      );
}

class AcceptedSkillSwap {
  const AcceptedSkillSwap({
    required this.id,
    required this.partnerName,
    required this.skillId,
    required this.skillName,
    required this.teacherId,
    required this.learnerId,
  });

  final String id;
  final String partnerName;
  final String skillId;
  final String skillName;
  final String teacherId;
  final String learnerId;

  /// Serialize ke JSON Map untuk disimpan ke local storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'partnerName': partnerName,
        'skillId': skillId,
        'skillName': skillName,
        'teacherId': teacherId,
        'learnerId': learnerId,
      };

  /// Deserialize dari JSON Map yang dibaca dari local storage.
  factory AcceptedSkillSwap.fromJson(Map<String, dynamic> json) =>
      AcceptedSkillSwap(
        id: json['id'] as String,
        partnerName: json['partnerName'] as String,
        skillId: json['skillId'] as String,
        skillName: json['skillName'] as String,
        teacherId: json['teacherId'] as String,
        learnerId: json['learnerId'] as String,
      );
}

class SkillSwapRequestDraft {
  const SkillSwapRequestDraft({
    required this.receiverId,
    required this.teachSkill,
    required this.learnSkill,
    required this.message,
  });

  final String receiverId;
  final String teachSkill;
  final String learnSkill;
  final String message;

  /// Serialize ke JSON Map untuk disimpan ke local storage.
  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'teachSkill': teachSkill,
        'learnSkill': learnSkill,
        'message': message,
      };

  /// Deserialize dari JSON Map yang dibaca dari local storage.
  factory SkillSwapRequestDraft.fromJson(Map<String, dynamic> json) =>
      SkillSwapRequestDraft(
        receiverId: json['receiverId'] as String,
        teachSkill: json['teachSkill'] as String,
        learnSkill: json['learnSkill'] as String,
        message: json['message'] as String,
      );
}

class SessionBookingDraft {
  const SessionBookingDraft({
    required this.requestId,
    required this.skillId,
    required this.teacherId,
    required this.learnerId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.mode,
    required this.meetingLink,
  });

  final String requestId;
  final String skillId;
  final String teacherId;
  final String learnerId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String mode;
  final String meetingLink;

  /// Serialize ke JSON Map untuk disimpan ke local storage.
  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'skillId': skillId,
        'teacherId': teacherId,
        'learnerId': learnerId,
        'date': date.toIso8601String(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'mode': mode,
        'meetingLink': meetingLink,
      };

  /// Deserialize dari JSON Map yang dibaca dari local storage.
  factory SessionBookingDraft.fromJson(Map<String, dynamic> json) =>
      SessionBookingDraft(
        requestId: json['requestId'] as String,
        skillId: json['skillId'] as String,
        teacherId: json['teacherId'] as String,
        learnerId: json['learnerId'] as String,
        date: DateTime.parse(json['date'] as String),
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: DateTime.parse(json['endTime'] as String),
        mode: json['mode'] as String,
        meetingLink: json['meetingLink'] as String,
      );
}
