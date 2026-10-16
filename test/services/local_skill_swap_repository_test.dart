import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillswap/models/workflow_models.dart';
import 'package:skillswap/services/local_skill_swap_repository.dart';
import 'package:skillswap/services/local_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('request and booking CRUD persist after repository is reopened',
      () async {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalSkillSwapRepository(
      LocalStorageService(preferences),
    );
    await repository.initialize();

    const request = SkillSwapRequestDraft(
      receiverId: 'seed_andi',
      teachSkill: 'ui-ux',
      learnSkill: 'python',
      message: 'Belajar Python bersama',
    );
    await repository.createRequest(request);

    const updatedRequest = SkillSwapRequestDraft(
      receiverId: 'seed_andi',
      teachSkill: 'ui-ux',
      learnSkill: 'python',
      message: 'Jadwal belajar Python',
    );
    await repository.updateRequest(0, updatedRequest);

    final booking = SessionBookingDraft(
      requestId: 'accepted_andi_python',
      skillId: 'python',
      teacherId: 'seed_andi',
      learnerId: 'seed_gabriel',
      date: DateTime(2026, 10, 20),
      startTime: DateTime(2026, 10, 20, 9),
      endTime: DateTime(2026, 10, 20, 10),
      mode: 'online',
      meetingLink: 'https://meet.google.com/abc-defg-hij',
    );
    await repository.createBooking(booking);

    final updatedBooking = SessionBookingDraft(
      requestId: booking.requestId,
      skillId: booking.skillId,
      teacherId: booking.teacherId,
      learnerId: booking.learnerId,
      date: booking.date,
      startTime: booking.startTime,
      endTime: DateTime(2026, 10, 20, 11),
      mode: booking.mode,
      meetingLink: booking.meetingLink,
    );
    await repository.updateBooking(0, updatedBooking);

    final reopenedRepository = LocalSkillSwapRepository(
      LocalStorageService(await SharedPreferences.getInstance()),
    );
    await reopenedRepository.initialize();

    expect(
      (await reopenedRepository.getCreatedRequests())
          .map((item) => item.toJson()),
      [updatedRequest.toJson()],
    );
    expect(
      (await reopenedRepository.getCreatedBookings())
          .map((item) => item.toJson()),
      [updatedBooking.toJson()],
    );
    expect(await reopenedRepository.getRequestCandidates(), isNotEmpty);

    await reopenedRepository.deleteRequest(0);
    await reopenedRepository.deleteBooking(0);
    expect(await reopenedRepository.getCreatedRequests(), isEmpty);
    expect(await reopenedRepository.getCreatedBookings(), isEmpty);
  });

  test('invalid collection index fails instead of silently doing nothing',
      () async {
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalSkillSwapRepository(
      LocalStorageService(preferences),
    );
    await repository.initialize();

    expect(repository.deleteRequest(0), throwsA(isA<RangeError>()));
  });
}
