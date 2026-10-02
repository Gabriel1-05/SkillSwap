import 'dart:async';

import 'package:skillswap/models/workflow_models.dart';
import 'package:skillswap/services/skill_swap_repository.dart';

class WorkflowTestRepository implements SkillSwapRepository {
  List<RequestCandidate> candidates = const [
    RequestCandidate(
      id: 'andi',
      name: 'Andi Pratama',
      teachSkillIds: ['python'],
    ),
  ];
  List<AcceptedSkillSwap> acceptedSkillSwaps = const [
    AcceptedSkillSwap(
      id: 'accepted-1',
      partnerName: 'Andi Pratama',
      skillId: 'python',
      skillName: 'Python',
      teacherId: 'andi',
      learnerId: 'gabriel',
    ),
  ];

  int candidateLoadFailures = 0;
  int bookingLoadFailures = 0;
  Completer<List<RequestCandidate>>? candidateLoadGate;
  Completer<List<AcceptedSkillSwap>>? bookingLoadGate;
  Completer<void>? requestSubmitGate;
  Completer<void>? bookingSubmitGate;
  final requests = <SkillSwapRequestDraft>[];
  final bookings = <SessionBookingDraft>[];

  @override
  Future<List<RequestCandidate>> getRequestCandidates() async {
    if (candidateLoadGate != null) return candidateLoadGate!.future;
    if (candidateLoadFailures > 0) {
      candidateLoadFailures--;
      throw StateError('load failed');
    }
    return candidates;
  }

  @override
  Future<void> createRequest(SkillSwapRequestDraft request) async {
    if (requestSubmitGate != null) await requestSubmitGate!.future;
    requests.add(request);
  }

  @override
  Future<List<AcceptedSkillSwap>> getAcceptedSkillSwaps() async {
    if (bookingLoadGate != null) return bookingLoadGate!.future;
    if (bookingLoadFailures > 0) {
      bookingLoadFailures--;
      throw StateError('load failed');
    }
    return acceptedSkillSwaps;
  }

  @override
  Future<void> createBooking(SessionBookingDraft booking) async {
    if (bookingSubmitGate != null) await bookingSubmitGate!.future;
    bookings.add(booking);
  }
}
