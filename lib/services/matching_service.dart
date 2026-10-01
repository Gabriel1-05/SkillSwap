import '../models/match_result.dart';
import '../models/user_model.dart';

class MatchingService {
  const MatchingService();

  MatchResult buildMatch(UserModel currentUser, UserModel candidate) {
    final skillMatch = currentUser.learnSkillIds
            .any(candidate.teachSkillIds.contains)
        ? 100.0
        : 0.0;
    final reverseMatch = candidate.learnSkillIds
            .any(currentUser.teachSkillIds.contains)
        ? 100.0
        : 0.0;
    final scheduleMatch = _scheduleMatch(
      currentUser.availability,
      candidate.availability,
    );
    final modeMatch = _modeMatch(
      currentUser.learningMode,
      candidate.learningMode,
    );
    final ratingScore = candidate.ratingCount == 0
        ? 0.0
        : (candidate.rating * 20).clamp(0.0, 100.0).toDouble();

    final score = (skillMatch * 50 +
            reverseMatch * 20 +
            scheduleMatch * 15 +
            modeMatch * 10 +
            ratingScore * 5) /
        100;

    return MatchResult(
      user: candidate,
      score: score,
      skillMatch: skillMatch,
      reverseMatch: reverseMatch,
      scheduleMatch: scheduleMatch,
      modeMatch: modeMatch,
      ratingScore: ratingScore,
    );
  }

  List<MatchResult> getRankedMatches(
    UserModel currentUser,
    List<UserModel> candidates,
  ) {
    final results = candidates
        .where((candidate) => candidate.id != currentUser.id)
        .map((candidate) => buildMatch(currentUser, candidate))
        .where((match) => match.skillMatch == 100)
        .toList();
    results.sort((first, second) => second.score.compareTo(first.score));
    return results;
  }

  double _scheduleMatch(List<String> first, List<String> second) {
    if (first.isEmpty || second.isEmpty) return 0;
    final denominator = first.length < second.length ? first.length : second.length;
    final overlap = first.toSet().intersection(second.toSet()).length;
    return overlap * 100 / denominator;
  }

  double _modeMatch(String first, String second) {
    if (first == second) return 100;
    if (first == 'flexible' || second == 'flexible') return 50;
    return 0;
  }
}