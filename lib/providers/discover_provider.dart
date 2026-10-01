import 'package:flutter/foundation.dart';

import '../models/match_result.dart';
import '../models/user_model.dart';
import '../models/view_state.dart';
import '../services/matching_service.dart';

class DiscoverProvider extends ChangeNotifier {
  DiscoverProvider({MatchingService matchingService = const MatchingService()})
      : _matchingService = matchingService {
    loadRecommendations();
  }

  final MatchingService _matchingService;
  final UserModel currentUser = demoUsers.first;
  List<MatchResult> matches = [];
  ViewState state = ViewState.idle;

  void loadRecommendations() {
    state = ViewState.loading;
    matches = _matchingService.getRankedMatches(
      currentUser,
      demoUsers.skip(1).toList(),
    );
    state = matches.isEmpty ? ViewState.empty : ViewState.loaded;
    notifyListeners();
  }
}

const demoUsers = <UserModel>[
  UserModel(
    id: 'seed_gabriel',
    name: 'Gabriel',
    university: 'Universitas Indonesia',
    major: 'Informatika',
    teachSkillIds: ['ui-ux', 'html-css'],
    learnSkillIds: ['python', 'data-science'],
    availability: [
      'mon_evening',
      'wed_evening',
      'sat_morning',
      'sat_afternoon',
      'sun_afternoon',
    ],
    learningMode: 'online',
    rating: 0,
    ratingCount: 0,
  ),
  UserModel(
    id: 'seed_andi',
    name: 'Andi Pratama',
    university: 'Universitas Indonesia',
    major: 'Sistem Informasi',
    teachSkillIds: ['python', 'data-science'],
    learnSkillIds: ['ui-ux'],
    availability: [
      'wed_evening',
      'fri_evening',
      'sat_afternoon',
      'sun_afternoon',
    ],
    learningMode: 'online',
    rating: 4.5,
    ratingCount: 4,
  ),
  UserModel(
    id: 'seed_sarah',
    name: 'Sarah',
    university: 'Universitas Indonesia',
    major: 'Ilmu Komunikasi',
    teachSkillIds: ['public-speaking'],
    learnSkillIds: ['photoshop'],
    availability: ['tue_evening', 'sat_afternoon'],
    learningMode: 'flexible',
    rating: 4.8,
    ratingCount: 5,
  ),
  UserModel(
    id: 'seed_kevin',
    name: 'Kevin',
    university: 'Universitas Indonesia',
    major: 'Desain Komunikasi Visual',
    teachSkillIds: ['photoshop'],
    learnSkillIds: ['public-speaking'],
    availability: ['tue_evening', 'sat_afternoon'],
    learningMode: 'offline',
    rating: 4.2,
    ratingCount: 3,
  ),
  UserModel(
    id: 'seed_dina',
    name: 'Dina',
    university: 'Universitas Indonesia',
    major: 'Sastra Inggris',
    teachSkillIds: ['english'],
    learnSkillIds: ['music-production'],
    availability: ['mon_afternoon', 'thu_evening'],
    learningMode: 'online',
    rating: 0,
    ratingCount: 0,
  ),
];