import '../models/workflow_models.dart';

abstract interface class SkillSwapRepository {
  Future<List<RequestCandidate>> getRequestCandidates();
  Future<void> createRequest(SkillSwapRequestDraft request);
  Future<List<AcceptedSkillSwap>> getAcceptedSkillSwaps();
  Future<void> createBooking(SessionBookingDraft booking);
}

class InMemorySkillSwapRepository implements SkillSwapRepository {
  InMemorySkillSwapRepository({
    List<RequestCandidate>? candidates,
    List<AcceptedSkillSwap>? acceptedSkillSwaps,
  })  : _candidates = candidates ?? _defaultCandidates,
        _acceptedSkillSwaps = acceptedSkillSwaps ?? _defaultAcceptedSkillSwaps;

  final List<RequestCandidate> _candidates;
  final List<AcceptedSkillSwap> _acceptedSkillSwaps;
  final List<SkillSwapRequestDraft> createdRequests = [];
  final List<SessionBookingDraft> createdBookings = [];

  static const _defaultCandidates = [
    RequestCandidate(
      id: 'seed_andi',
      name: 'Andi Pratama',
      teachSkillIds: ['python', 'data-science'],
    ),
    RequestCandidate(
      id: 'seed_sarah',
      name: 'Sarah',
      teachSkillIds: ['photoshop'],
    ),
    RequestCandidate(
      id: 'seed_kevin',
      name: 'Kevin',
      teachSkillIds: ['photoshop'],
    ),
  ];

  static const _defaultAcceptedSkillSwaps = [
    AcceptedSkillSwap(
      id: 'accepted_andi_python',
      partnerName: 'Andi Pratama',
      skillId: 'python',
      skillName: 'Python',
      teacherId: 'seed_andi',
      learnerId: 'seed_gabriel',
    ),
  ];

  @override
  Future<List<RequestCandidate>> getRequestCandidates() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_candidates);
  }

  @override
  Future<void> createRequest(SkillSwapRequestDraft request) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    createdRequests.add(request);
  }

  @override
  Future<List<AcceptedSkillSwap>> getAcceptedSkillSwaps() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_acceptedSkillSwaps);
  }

  @override
  Future<void> createBooking(SessionBookingDraft booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!booking.endTime.isAfter(booking.startTime)) {
      throw const FormatException('Waktu selesai harus setelah waktu mulai.');
    }
    if (booking.mode == 'online' &&
        Uri.tryParse(booking.meetingLink)?.hasAbsolutePath != true) {
      throw const FormatException('Tautan meeting tidak valid.');
    }
    createdBookings.add(booking);
  }
}
