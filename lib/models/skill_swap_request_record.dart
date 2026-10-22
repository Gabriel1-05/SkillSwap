class SkillSwapRequestRecord {
  const SkillSwapRequestRecord({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.teachSkillId,
    required this.learnSkillId,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final String teachSkillId;
  final String learnSkillId;
  final String message;
  final String status;
  final DateTime createdAt;

  factory SkillSwapRequestRecord.fromJson(Map<String, dynamic> json) {
    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Field "$key" harus berupa teks yang tidak kosong.');
      }
      return value;
    }

    final createdAtValue = json['created_at'];
    final DateTime createdAt;
    if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else if (createdAtValue is String) {
      final parsed = DateTime.tryParse(createdAtValue);
      if (parsed == null) {
        throw const FormatException('Field "created_at" bukan tanggal valid.');
      }
      createdAt = parsed;
    } else {
      throw const FormatException('Field "created_at" bukan tanggal valid.');
    }

    final record = SkillSwapRequestRecord(
      id: requiredString('id'),
      senderId: requiredString('sender_id'),
      receiverId: requiredString('receiver_id'),
      teachSkillId: requiredString('teach_skill_id'),
      learnSkillId: requiredString('learn_skill_id'),
      message: requiredString('message'),
      status: requiredString('status'),
      createdAt: createdAt,
    );
    record.validate();
    return record;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'teach_skill_id': teachSkillId,
        'learn_skill_id': learnSkillId,
        'message': message,
        'status': status,
        'created_at': createdAt.toIso8601String(),
      };

  void validate() {
    if (id.trim().isEmpty ||
        senderId.trim().isEmpty ||
        receiverId.trim().isEmpty ||
        teachSkillId.trim().isEmpty ||
        learnSkillId.trim().isEmpty) {
      throw const FormatException('Identitas request dan skill wajib diisi.');
    }
    if (senderId == receiverId) {
      throw const FormatException('Pengirim dan penerima harus berbeda.');
    }
    if (message.trim().isEmpty || message.trim().length > 300) {
      throw const FormatException('Pesan harus berisi 1 sampai 300 karakter.');
    }
    if (!const ['pending', 'accepted', 'declined', 'cancelled']
        .contains(status)) {
      throw const FormatException('Status request tidak valid.');
    }
  }
}
