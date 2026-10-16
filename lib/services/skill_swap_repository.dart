import '../models/workflow_models.dart';

abstract interface class SkillSwapRepository {
  Future<List<RequestCandidate>> getRequestCandidates();
  Future<void> createRequest(SkillSwapRequestDraft request);
  Future<List<SkillSwapRequestDraft>> getCreatedRequests();
  Future<void> updateRequest(int index, SkillSwapRequestDraft request);
  Future<void> deleteRequest(int index);
  Future<List<AcceptedSkillSwap>> getAcceptedSkillSwaps();
  Future<void> createBooking(SessionBookingDraft booking);
  Future<List<SessionBookingDraft>> getCreatedBookings();
  Future<void> updateBooking(int index, SessionBookingDraft booking);
  Future<void> deleteBooking(int index);
  Future<void> clearAllData();
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

  @override
  Future<List<SkillSwapRequestDraft>> getCreatedRequests() async =>
      List.unmodifiable(createdRequests);

  @override
  Future<List<SessionBookingDraft>> getCreatedBookings() async =>
      List.unmodifiable(createdBookings);

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
  Future<void> updateRequest(int index, SkillSwapRequestDraft request) async {
    createdRequests[index] = request;
  }

  @override
  Future<void> deleteRequest(int index) async {
    createdRequests.removeAt(index);
  }

  @override
  Future<List<AcceptedSkillSwap>> getAcceptedSkillSwaps() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_acceptedSkillSwaps);
  }

  @override
  Future<void> createBooking(SessionBookingDraft booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _validateBooking(booking);
    createdBookings.add(booking);
  }

  void _validateBooking(SessionBookingDraft booking) {
    if (!booking.endTime.isAfter(booking.startTime)) {
      throw const FormatException('Waktu selesai harus setelah waktu mulai.');
    }
    final uri = Uri.tryParse(booking.meetingLink);
    if (booking.mode == 'online' &&
        (uri == null ||
            !uri.hasAuthority ||
            !['http', 'https'].contains(uri.scheme))) {
      throw const FormatException('Tautan meeting tidak valid.');
    }
  }

  @override
  Future<void> updateBooking(int index, SessionBookingDraft booking) async {
    _validateBooking(booking);
    createdBookings[index] = booking;
  }

  @override
  Future<void> deleteBooking(int index) async {
    createdBookings.removeAt(index);
  }

  @override
  Future<void> clearAllData() async {
    createdRequests.clear();
    createdBookings.clear();
  }
}
