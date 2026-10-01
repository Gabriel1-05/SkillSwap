import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/models/user_model.dart';
import 'package:skillswap/services/matching_service.dart';

void main() {
  const service = MatchingService();

  const gabriel = UserModel(
    id: 'gabriel',
    name: 'Gabriel',
    university: 'Universitas Indonesia',
    major: 'Informatika',
    teachSkillIds: ['ui-ux'],
    learnSkillIds: ['python'],
    availability: ['mon_evening', 'wed_evening', 'sat_morning', 'sat_afternoon', 'sun_afternoon'],
    learningMode: 'online',
    rating: 0,
    ratingCount: 0,
  );

  const andi = UserModel(
    id: 'andi',
    name: 'Andi',
    university: 'Universitas Indonesia',
    major: 'Informatika',
    teachSkillIds: ['python'],
    learnSkillIds: ['ui-ux'],
    availability: ['wed_evening', 'fri_evening', 'sat_afternoon', 'sun_afternoon'],
    learningMode: 'online',
    rating: 4.5,
    ratingCount: 4,
  );

  test('scores the documented two-way example and rounds to 96%', () {
    final result = service.buildMatch(gabriel, andi);

    expect(result.scheduleMatch, 75);
    expect(result.score, 95.75);
    expect(result.displayPercent, 96);
    expect(result.isTwoWay, isTrue);
  });

  test('does not award rating points before the candidate has reviews', () {
    final unrated = UserModel(
      id: andi.id,
      name: andi.name,
      university: andi.university,
      major: andi.major,
      teachSkillIds: andi.teachSkillIds,
      learnSkillIds: andi.learnSkillIds,
      availability: andi.availability,
      learningMode: andi.learningMode,
      rating: 5,
      ratingCount: 0,
    );

    expect(service.buildMatch(gabriel, unrated).ratingScore, 0);
  });

  test('returns zero schedule match when either availability is empty', () {
    final unavailable = UserModel(
      id: andi.id,
      name: andi.name,
      university: andi.university,
      major: andi.major,
      teachSkillIds: andi.teachSkillIds,
      learnSkillIds: andi.learnSkillIds,
      availability: const [],
      learningMode: andi.learningMode,
      rating: andi.rating,
      ratingCount: andi.ratingCount,
    );

    expect(service.buildMatch(gabriel, unavailable).scheduleMatch, 0);
  });

  test('keeps only direct skill matches and orders them by score', () {
    final other = UserModel(
      id: 'other',
      name: 'Other',
      university: 'Universitas Indonesia',
      major: 'Informatika',
      teachSkillIds: ['python'],
      learnSkillIds: const [],
      availability: const [],
      learningMode: 'offline',
      rating: 0,
      ratingCount: 0,
    );

    expect(service.getRankedMatches(gabriel, [other, andi]).map((match) => match.user.id), ['andi', 'other']);
    expect(service.getRankedMatches(gabriel, [gabriel]).isEmpty, isTrue);
  });
}