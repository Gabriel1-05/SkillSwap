class RequestCandidate {
  const RequestCandidate({
    required this.id,
    required this.name,
    required this.teachSkillIds,
  });

  final String id;
  final String name;
  final List<String> teachSkillIds;
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
}
