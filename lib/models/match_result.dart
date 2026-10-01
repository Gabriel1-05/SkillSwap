import 'user_model.dart';

class MatchResult {
  const MatchResult({
    required this.user,
    required this.score,
    required this.skillMatch,
    required this.reverseMatch,
    required this.scheduleMatch,
    required this.modeMatch,
    required this.ratingScore,
  });

  final UserModel user;
  final double score;
  final double skillMatch;
  final double reverseMatch;
  final double scheduleMatch;
  final double modeMatch;
  final double ratingScore;

  int get displayPercent => score.round();

  bool get isTwoWay => reverseMatch == 100;
}